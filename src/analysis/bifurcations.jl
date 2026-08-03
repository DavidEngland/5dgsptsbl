function _bt_qtheta(e_tilde, u_slow, p::SBLParams)
    S = u_slow[1]
    ell = mixing_length(z_eff(p.z1, p), p)
    numerator = 0.5 * p.cm * ell * S^2 - ((1.5 + p.Ctheta) * e_tilde^2 / ell)
    denominator = 2 * (p.g / p.theta0) * p.ctheta * ell
    return numerator / denominator
end

function _bt_det_on_trace(e_tilde, u_slow, p::SBLParams)
    q_theta = _bt_qtheta(e_tilde, u_slow, p)
    return jacobian_determinant(SVector(e_tilde, q_theta), u_slow, p)
end

function _bisect_root(f, left, right; maxiter = 64)
    f_left = f(left)
    f_right = f(right)
    if !isfinite(f_left) || !isfinite(f_right) || sign(f_left) == sign(f_right)
        return nothing
    end

    for _ in 1:maxiter
        mid = (left + right) / 2
        f_mid = f(mid)
        if !isfinite(f_mid)
            return nothing
        elseif iszero(f_mid) || abs(right - left) <= eps(mid) * 8
            return mid
        elseif sign(f_mid) == sign(f_left)
            left = mid
            f_left = f_mid
        else
            right = mid
            f_right = f_mid
        end
    end

    return (left + right) / 2
end

function tracking_codim2_points(u_slow, p::SBLParams; e_bounds = (1e-4, 10.0), samples = 256)
    Ts = u_slow[2]
    cusp_state = SVector(zero(eltype(u_slow)), zero(eltype(u_slow)))
    cusp_residual = fast_2d_rhs(cusp_state, SVector(zero(eltype(u_slow)), Ts), p)
    cusp = (
        state = cusp_state,
        slow_state = SVector(zero(eltype(u_slow)), Ts),
        exists = isapprox(u_slow[1], zero(u_slow[1]); atol = sqrt(eps(eltype(u_slow)))),
        residual = norm(cusp_residual),
        second_derivative = zero(eltype(u_slow)),
    )

    left, right = e_bounds
    grid = range(left, right; length = samples)
    root = nothing
    prev_e = first(grid)
    prev_f = _bt_det_on_trace(prev_e, u_slow, p)
    for e_tilde in Iterators.drop(grid, 1)
        current_f = _bt_det_on_trace(e_tilde, u_slow, p)
        if isfinite(prev_f) && isfinite(current_f) && sign(prev_f) != sign(current_f)
            root = _bisect_root(e -> _bt_det_on_trace(e, u_slow, p), prev_e, e_tilde)
            break
        end
        prev_e = e_tilde
        prev_f = current_f
    end

    bt = if isnothing(root)
        (state = nothing, exists = false, trace = nothing, determinant = nothing)
    else
        q_theta = _bt_qtheta(root, u_slow, p)
        state = SVector(root, q_theta)
        (
            state = state,
            exists = true,
            trace = fast_trace(state, u_slow, p),
            determinant = jacobian_determinant(state, u_slow, p),
        )
    end

    return (cusp = cusp, bogdanov_takens = bt)
end

@inline hysteresis_width(Pi_G, Pi_G_crit; CH = 0.42) = CH * sqrt(max(zero(Pi_G), Pi_G_crit - Pi_G))