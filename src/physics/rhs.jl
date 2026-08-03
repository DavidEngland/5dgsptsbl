@inline function _state(u, idx)
    return u[idx]
end

@inline _desingularization_scale(e_tilde, params::SBLParams) = smooth_desingularization_scale(e_tilde, params)

@inline function shear_forcing(S::T, params::SBLParams) where {T<:Real}
    return (params.S_geo - S) / params.tau_S
end

@inline function net_radiation(Ts::T, params::SBLParams) where {T<:Real}
    sigma = convert(promote_type(T, typeof(params.theta0)), 5.670374419e-8)
    R0 = params.R_down - params.emissivity * sigma * params.theta0^4
    dR_dT = -4 * params.emissivity * sigma * params.theta0^3
    return R0 + dR_dT * (Ts - params.theta0)
end

@inline function gspt_5d_rhs!(du, u, p::SBLParams, tau)
    e_tilde = _state(u, 1)
    q_theta = _state(u, 2)
    S = _state(u, 3)
    Ts = _state(u, 4)
    Tg = _state(u, 5)

    ell = mixing_length(z_eff(p.z1, p), p)
    theta_term = theta_z(Ts, e_tilde, p)
    inv_e = one(e_tilde) / _desingularization_scale(e_tilde, p)
    momentum_forcing = shear_forcing(S, p)
    heat_forcing = net_radiation(Ts, p)

    du[1] = 0.5 * p.cm * ell * S^2 * e_tilde - (p.g / (2 * p.theta0)) * q_theta - (0.5 / ell) * e_tilde^3
    du[2] = -p.cw * theta_term * e_tilde^3 - (p.g / p.theta0) * p.ctheta * ell * q_theta^2 - (p.Ctheta / ell) * e_tilde^2 * q_theta
    du[3] = p.eps1 * inv_e * momentum_forcing
    du[4] = p.eps1 * inv_e * (one(Ts) / p.Cs) * (heat_forcing + p.rho * p.cp * q_theta + (p.kg / p.dg) * (Tg - Ts))
    du[5] = p.eps1 * p.eps2 * inv_e * (p.kappag / p.dg^2) * (Ts - Tg)
    return nothing
end

@inline function fast_2d_rhs(u_fast, u_slow, p::SBLParams)
    e_tilde = _state(u_fast, 1)
    q_theta = _state(u_fast, 2)
    S = _state(u_slow, 1)
    Ts = _state(u_slow, 2)
    ell = mixing_length(z_eff(p.z1, p), p)
    theta_term = theta_z(Ts, e_tilde, p)

    return SVector(
        0.5 * p.cm * ell * S^2 * e_tilde - (p.g / (2 * p.theta0)) * q_theta - (0.5 / ell) * e_tilde^3,
        -p.cw * theta_term * e_tilde^3 - (p.g / p.theta0) * p.ctheta * ell * q_theta^2 - (p.Ctheta / ell) * e_tilde^2 * q_theta,
    )
end