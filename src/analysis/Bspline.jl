#!/usr/bin/env julia
#src/analysis/Bspline.jl
using LinearAlgebra

"""
    eval_bspline_matrices(tau_vec::Vector{T}, knots::Vector{T}, p::Int) where {T<:Real}

Computes the (N × M) basis evaluation matrix `Phi` and derivative matrix `DPhi`
over the intrinsic time grid `tau_vec` using an iterative Cox-de Boor algorithm.
Vectorized over N and degree p to eliminate recursion bottlenecks.
"""
function eval_bspline_matrices(tau_vec::Vector{T}, knots::Vector{T}, p::Int) where {T<:Real}
    N = length(tau_vec)
    num_knots = length(knots)
    M_p1 = num_knots - p - 1 # Number of basis functions of degree p
    M_p0 = num_knots - p     # Number of basis functions of degree p-1

    # 1. Degree 0 basis matrix
    Phi_prev = zeros(T, N, M_p0)
    @inbounds for i in 1:N
        tau = tau_vec[i]
        for j in 1:M_p0
            if tau == knots[end] && j == M_p0 - 1
                Phi_prev[i, j] = one(T)
            elseif knots[j] <= tau < knots[j+1]
                Phi_prev[i, j] = one(T)
            end
        end
    end

    # 2. Iterate up to degree p-1 and degree p
    Phi_curr = zeros(T, N, M_p0)
    for deg in 1:p
        M_deg = num_knots - deg - 1
        Phi_curr = zeros(T, N, M_deg)
        @inbounds for j in 1:M_deg
            denom1 = knots[j+deg] - knots[j]
            denom2 = knots[j+deg+1] - knots[j+1]

            inv1 = denom1 > 0 ? one(T) / denom1 : zero(T)
            inv2 = denom2 > 0 ? one(T) / denom2 : zero(T)

            for i in 1:N
                tau = tau_vec[i]
                t1 = inv1 > 0 ? (tau - knots[j]) * inv1 * Phi_prev[i, j] : zero(T)
                t2 = inv2 > 0 ? (knots[j+deg+1] - tau) * inv2 * Phi_prev[i, j+1] : zero(T)
                Phi_curr[i, j] = t1 + t2
            end
        end
        if deg < p
            Phi_prev = Phi_curr
        end
    end

    # Basis matrix at degree p
    Phi = Phi_curr

    # 3. Exact derivative matrix DPhi constructed from degree p-1 basis Phi_prev
    DPhi = zeros(T, N, M_p1)
    @inbounds for j in 1:M_p1
        denom1 = knots[j+p] - knots[j]
        denom2 = knots[j+p+1] - knots[j+1]

        inv1 = denom1 > 0 ? p / denom1 : zero(T)
        inv2 = denom2 > 0 ? p / denom2 : zero(T)

        for i in 1:N
            term1 = inv1 > 0 ? inv1 * Phi_prev[i, j] : zero(T)
            term2 = inv2 > 0 ? inv2 * Phi_prev[i, j+1] : zero(T)
            DPhi[i, j] = term1 - term2
        end
    end

    return Phi, DPhi
end

"""
    build_intrinsic_bspline_library(t_vec, X_data, Psi_vec;
                                     num_splines=50, poly_order=3,
                                     psi_floor=1e-4, check_partition=true)

Production-grade intrinsic-time WSINDy feature library builder.

# Key Features:
- **Exact Boundary Vanishing**: Trims endpoint basis functions so φ = φ_τ = 0 at domain limits.
- **Open Knot Vector**: Uses (p + 1) repeated knots at both boundaries.
- **BLAS Acceleration**: Replaces element-wise numerical integration with BLAS matrix products.
- **Non-Recursive de Boor**: Evaluates B-splines iteratively in O(p²) operations.
"""
function build_intrinsic_bspline_library(
    t_vec::Vector{Float64},
    X_data::Matrix{Float64},
    Psi_vec::Vector{Float64};
    num_splines::Int=50,
    poly_order::Int=3,
    psi_floor::Float64=1e-4,
    check_partition::Bool=true
)
    N, d = size(X_data)
    p = poly_order

    # 1. Desingularized Intrinsic Time Transformation: τ(t) = ∫ [1 / Ψ(s)] ds
    d_tau = 1.0 ./ max.(Psi_vec, psi_floor)
    tau_vec = zeros(N)
    @inbounds for i in 2:N
        tau_vec[i] = tau_vec[i-1] + 0.5 * (d_tau[i-1] + d_tau[i]) * (t_vec[i] - t_vec[i-1])
    end

    # 2. Construct Open Knot Vector with (p + 1) repeated boundary knots
    tau_min, tau_max = tau_vec[1], tau_vec[end]
    num_internal = num_splines - p + 1
    internal_knots = collect(range(tau_min, tau_max, length=num_internal))

    knots = vcat(fill(tau_min, p + 1), internal_knots[2:(end-1)], fill(tau_max, p + 1))

    # 3. Efficient Iterative B-Spline Matrix Evaluation
    Phi, DPhi = eval_bspline_matrices(tau_vec, knots, p)

    # Partition of Unity Check across the interior domain
    if check_partition
        partition_sum = sum(Phi, dims=2)
        @assert all(abs.(partition_sum .- 1.0) .< 1e-8) "B-spline partition of unity check failed."
    end

    # 4. Trim Boundary Basis Functions (Option A: Exact φ = φ_τ = 0 at boundaries)
    # Trimming the first and last (p - 1) splines eliminates non-zero boundary terms
    trim_idx = p
    active_mask = (trim_idx+1):(size(Phi, 2)-trim_idx)

    Phi_active = Phi[:, active_mask]   # Size: N × M_active
    DPhi_active = DPhi[:, active_mask]  # Size: N × M_active

    # 5. Expanded Physics-Driven Candidate Feature Library Θ(X)
    e = @view X_data[:, 1]
    q = @view X_data[:, 2]
    tm = @view X_data[:, 3]
    S = @view X_data[:, 4]
    Tz = @view X_data[:, 5]

    Theta = hcat(
        ones(N), e, q, tm, S, Tz,
        e .^ 2, e .* S, q .* Tz, e .^ 3, e .^ 1.5,
        e .* q, S .* Tz, q .* S, e .* Tz
    )
    num_features = size(Theta, 2)

    # 6. BLAS-Accelerated Numerical Quadrature
    # Trapezoidal Integration Weight Vector w
    w = zeros(N)
    w[1] = 0.5 * (tau_vec[2] - tau_vec[1])
    w[end] = 0.5 * (tau_vec[end] - tau_vec[end-1])
    @inbounds for i in 2:(N-1)
        w[i] = 0.5 * (tau_vec[i+1] - tau_vec[i-1])
    end

    # Integrate against Ψ(t) scaled library: G = Φ_active' * diag(w .* Ψ) * Θ
    Theta_scaled = (w .* Psi_vec) .* Theta
    G_matrix = Phi_active' * Theta_scaled        # Size: M_active × num_features

    # Integrate weak target derivatives: B = -DΦ_active' * diag(w) * X
    X_scaled = w .* X_data
    b_vector = -DPhi_active' * X_scaled          # Size: M_active × d

    return G_matrix, b_vector
end