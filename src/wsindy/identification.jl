@inline function _finite_difference_derivative(values, tau)
    n = length(values)
    derivative = similar(values)
    derivative[1] = (values[2] - values[1]) / (tau[2] - tau[1])
    for i in 2:n-1
        derivative[i] = (values[i + 1] - values[i - 1]) / (tau[i + 1] - tau[i - 1])
    end
    derivative[n] = (values[n] - values[n - 1]) / (tau[n] - tau[n - 1])
    return derivative
end

@inline function _threshold_coefficients(coefficients, lambda)
    thresholded = copy(coefficients)
    for i in eachindex(thresholded)
        if abs(thresholded[i]) < lambda
            thresholded[i] = zero(thresholded[i])
        end
    end
    return thresholded
end

function identify_gspt_closures(tau, e_tilde, q_theta, S, Ts, params::SBLParams; lambda = 1e-2)
    tau = collect(tau)
    e_tilde = collect(e_tilde)
    q_theta = collect(q_theta)
    S = collect(S)
    Ts = collect(Ts)

    ell = mixing_length(z_eff(params.z1, params), params)
    theta_term = map((ts, e) -> theta_z(ts, e, params), Ts, e_tilde)

    phi1 = 0.5 .* ell .* S .^ 2 .* e_tilde
    phi2 = -theta_term .* e_tilde .^ 3
    phi3 = -(params.g / params.theta0) .* ell .* q_theta .^ 2
    phi4 = -(1 / ell) .* e_tilde .^ 2 .* q_theta
    features = hcat(phi1, phi2, phi3, phi4)

    target_e = _finite_difference_derivative(e_tilde, tau)
    target_q = _finite_difference_derivative(q_theta, tau)

    coefficients_e = features \ target_e
    coefficients_q = features \ target_q

    recovered_cm = _threshold_coefficients(coefficients_e, lambda)[1]
    recovered_cw = _threshold_coefficients(coefficients_q, lambda)[2]
    recovered_ctheta = _threshold_coefficients(coefficients_q, lambda)[3]
    recovered_Ctheta = _threshold_coefficients(coefficients_q, lambda)[4]

    residual_e = norm(features * coefficients_e - target_e) / max(norm(target_e), eps(eltype(target_e)))
    residual_q = norm(features * coefficients_q - target_q) / max(norm(target_q), eps(eltype(target_q)))

    return (
        cm = recovered_cm,
        cw = recovered_cw,
        ctheta = recovered_ctheta,
        Ctheta = recovered_Ctheta,
        lambda = lambda,
        residual_e = residual_e,
        residual_q = residual_q,
        coefficients_e = coefficients_e,
        coefficients_q = coefficients_q,
    )
end