# src/physics/closures.jl
"""
    smooth_max(x, eps)

C^∞ algebraic hyperbolic embedding approximation of `max(0, x)`.
"""
@inline function smooth_max(x, eps)
    return 0.5 * (x + sqrt(x^2 + eps^2))
end

"""
    smooth_max_derivative(x, eps)

Exact derivative d/dx of the algebraic smooth max embedding.
"""
@inline function smooth_max_derivative(x, eps)
    return 0.5 * (one(x) + x / sqrt(x^2 + eps^2))
end

@inline function z_eff(z, params::SBLParams)
    return z - params.d + params.z0m
end

@inline function mixing_length(z_eff_value, params::SBLParams)
    numerator = params.kappa * z_eff_value
    return numerator / (one(numerator) + numerator / params.ell_inf)
end

@inline function h_sbl(e_tilde, params::SBLParams)
    return params.h_min + params.L_e * e_tilde
end

@inline function dh_sbl_de(e_tilde, params::SBLParams)
    return params.L_e
end

@inline function stratification(Ts, e_tilde, params::SBLParams)
    raw_grad = (params.theta0 - Ts) / h_sbl(e_tilde, params)
    return smooth_max(raw_grad, params.eps_strat)
end

@inline function theta_z(Ts, e_tilde, params::SBLParams)
    return stratification(Ts, e_tilde, params)
end

"""
    stratification_with_derivative(Ts, e_tilde, params)

Return `(theta_z, dtheta_z_de)` analytically for use in Jacobian calculations.
"""
@inline function stratification_with_derivative(Ts, e_tilde, params::SBLParams)
    h = h_sbl(e_tilde, params)
    dh_de = dh_sbl_de(e_tilde, params)
    raw_grad = (params.theta0 - Ts) / h

    theta = smooth_max(raw_grad, params.eps_strat)
    dtheta_draw = smooth_max_derivative(raw_grad, params.eps_strat)
    draw_de = -((params.theta0 - Ts) / (h^2)) * dh_de

    return theta, dtheta_draw * draw_de
end

@inline function eddy_diffusivity(ell, e_tilde)
    return ell * e_tilde
end

@inline function bulk_drag_coef(params::SBLParams)
    return (params.kappa / log((params.z1 - params.d) / params.z0m))^2
end

@inline function bulk_heat_coef(params::SBLParams)
    return (params.kappa^2) / (log((params.z1 - params.d) / params.z0m) * log((params.z1 - params.d) / params.z0h))
end

@inline function transcritical_ignition_shear(Ts, e_tilde, params::SBLParams)
    ell = mixing_length(z_eff(params.z1, params), params)
    theta_term = theta_z(Ts, e_tilde, params)
    ignition_sq = (3 * params.g * params.cw * theta_term) / (params.theta0 * params.cm * params.Ctheta) +
                  (3 * params.delta) / (params.cm * ell^2)
    return sqrt(max(zero(ignition_sq), ignition_sq))
end