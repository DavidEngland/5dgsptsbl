# src/physics/closures.jl
"""
    smooth_max(x, eps)

C^∞ algebraic hyperbolic embedding approximation of `max(0, x)`.
"""
@inline function smooth_max(x, eps)
    return 0.5 * (x + sqrt(x^2 + eps^2))
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

@inline function stratification(Ts, e_tilde, params::SBLParams)
    raw_grad = (params.theta0 - Ts) / h_sbl(e_tilde, params)
    return smooth_max(raw_grad, params.eps_strat)
end

@inline function theta_z(Ts, e_tilde, params::SBLParams)
    return stratification(Ts, e_tilde, params)
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