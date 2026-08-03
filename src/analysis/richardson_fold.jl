@inline function cooling_parameter(R_net, G, H_max)
    return (R_net - G) / H_max
end

@inline function ri_fold_from_pi(Pi; c_s = 0.22, pi_upper = 1 - 1e-9)
    Pi_bounded = clamp(Pi, zero(Pi), pi_upper)
    return c_s / (one(Pi_bounded) - Pi_bounded)
end

@inline function ri_fold_dynamic(R_net, G, H_max; c_s = 0.22, pi_upper = 1 - 1e-9)
    Pi = cooling_parameter(R_net, G, H_max)
    return ri_fold_from_pi(Pi; c_s = c_s, pi_upper = pi_upper)
end

@inline function ri_fold_flux_form(R_net, G, H; beta_h = 5.0)
    return (one(H) / (2 * beta_h)) * (one(H) - (R_net - G) / H)
end
