struct SCMGrid{T<:Real,V<:AbstractVector{T}}
    z::V
    dz::V
    z_half::V
end

function SCMGrid(z::AbstractVector{T}) where {T<:Real}
    length(z) >= 2 || throw(ArgumentError("SCMGrid requires at least two vertical levels"))
    dz = similar(z)
    z_half = similar(z, length(z) - 1)

    for i in eachindex(z_half)
        z_half[i] = (z[i] + z[i + 1]) / 2
    end

    dz[1] = z[2] - z[1]
    for i in 2:length(z)-1
        dz[i] = (z[i + 1] - z[i - 1]) / 2
    end
    dz[end] = z[end] - z[end - 1]

    return SCMGrid(collect(z), dz, z_half)
end

struct SCMParameters{G,P,V<:AbstractVector}
    grid::G
    params::P
    ug::V
    vg::V
    gamma::Float64
end

function SCMParameters(grid::SCMGrid, params::SBLParams; ug = fill(params.S_geo, length(grid.z)), vg = fill(zero(params.S_geo), length(grid.z)), gamma = 0.4)
    return SCMParameters(grid, params, collect(ug), collect(vg), gamma)
end

@inline function scm_boundary_layer_depth(e_tilde, grid::SCMGrid; gamma = 0.4)
    numerator = sum(grid.z .* e_tilde .* grid.dz)
    denominator = sum(e_tilde .* grid.dz)
    return gamma * numerator / max(denominator, eps(eltype(e_tilde)))
end

function scm_interface_diffusivities(e_tilde, grid::SCMGrid, params::SBLParams)
    diffusivities = similar(e_tilde, length(grid.z_half))
    for i in eachindex(diffusivities)
        ell_eff = mixing_length(z_eff(grid.z_half[i], params), params)
        diffusivities[i] = ell_eff * ((e_tilde[i] + e_tilde[i + 1]) / 2)
    end
    return diffusivities
end

function scm_rhs!(du, u, p::SCMParameters, t)
    grid = p.grid
    params = p.params
    n = length(grid.z)

    e_tilde = @view u[1:n]
    q_theta = @view u[n + 1:2n]
    uvel = @view u[2n + 1:3n]
    vvel = @view u[3n + 1:4n]
    theta = @view u[4n + 1:5n]

    de = @view du[1:n]
    dq = @view du[n + 1:2n]
    duvel = @view du[2n + 1:3n]
    dvvel = @view du[3n + 1:4n]
    dtheta = @view du[4n + 1:5n]

    fill!(de, zero(eltype(du)))
    fill!(dq, zero(eltype(du)))

    K = scm_interface_diffusivities(e_tilde, grid, params)
    h_eff = scm_boundary_layer_depth(e_tilde, grid; gamma = p.gamma)

    heat_flux = similar(theta)
    for k in eachindex(theta)
        theta_grad = smooth_max((params.theta0 - theta[k]) / max(h_eff, eps(eltype(theta))), params.eps_strat)
        heat_flux[k] = -params.cw * theta_grad * e_tilde[k]^3
        dq[k] = heat_flux[k] - (params.Ctheta / mixing_length(z_eff(grid.z[k], params), params)) * e_tilde[k]^2 * q_theta[k]
    end

    for k in 1:n
        Km_up = k < n ? K[k] : zero(eltype(du))
        Km_dn = k > 1 ? K[k - 1] : zero(eltype(du))

        up_grad = k < n ? (uvel[k + 1] - uvel[k]) / (grid.z[k + 1] - grid.z[k]) : zero(eltype(du))
        dn_grad = k > 1 ? (uvel[k] - uvel[k - 1]) / (grid.z[k] - grid.z[k - 1]) : zero(eltype(du))
        duvel[k] = (Km_up * up_grad - Km_dn * dn_grad) / grid.dz[k] + (p.vg[k] - vvel[k])

        up_grad = k < n ? (vvel[k + 1] - vvel[k]) / (grid.z[k + 1] - grid.z[k]) : zero(eltype(du))
        dn_grad = k > 1 ? (vvel[k] - vvel[k - 1]) / (grid.z[k] - grid.z[k - 1]) : zero(eltype(du))
        dvvel[k] = (Km_up * up_grad - Km_dn * dn_grad) / grid.dz[k] - (p.ug[k] - uvel[k])

        q_up = k < n ? heat_flux[k + 1] : zero(eltype(du))
        q_dn = k > 1 ? heat_flux[k - 1] : zero(eltype(du))
        dtheta[k] = -(q_up - q_dn) / grid.dz[k]
    end

    return nothing
end