function fast_jacobian(u_fast, u_slow, p::SBLParams)
    return ForwardDiff.jacobian(v -> fast_2d_rhs(v, u_slow, p), u_fast)
end

function fast_trace(u_fast, u_slow, p::SBLParams)
    e_tilde = u_fast[1]
    q_theta = u_fast[2]
    S = u_slow[1]

    ell = mixing_length(z_eff(p.z1, p), p)
    df1_de = 0.5 * p.cm * ell * S^2 - 1.5 * e_tilde^2 / ell
    df2_dq = -2 * (p.g / p.theta0) * p.ctheta * ell * q_theta - (p.Ctheta / ell) * e_tilde^2

    return df1_de + df2_dq
end

"""
    jacobian_determinant(u_fast, u_slow, p::SBLParams)

Compute the exact 2D fast-subsystem Jacobian determinant at
`u_fast = (e_tilde, q_theta)` and `u_slow = (S, Ts)`.
"""
function jacobian_determinant(u_fast, u_slow, p::SBLParams)
    e_tilde = u_fast[1]
    q_theta = u_fast[2]
    S = u_slow[1]
    Ts = u_slow[2]

    ell = mixing_length(z_eff(p.z1, p), p)
    theta_term, dtheta_de = stratification_with_derivative(Ts, e_tilde, p)

    df1_de = 0.5 * p.cm * ell * S^2 - 1.5 * e_tilde^2 / ell
    df1_dq = -0.5 * p.g / p.theta0
    df2_de = -p.cw * (3 * theta_term * e_tilde^2 + e_tilde^3 * dtheta_de) - 2 * (p.Ctheta / ell) * e_tilde * q_theta
    df2_dq = -2 * (p.g / p.theta0) * p.ctheta * ell * q_theta - (p.Ctheta / ell) * e_tilde^2

    return df1_de * df2_dq - df1_dq * df2_de
end

function _fold_determinant(e_tilde, q_theta, u_slow, p::SBLParams)
    return jacobian_determinant(SVector(e_tilde, q_theta), u_slow, p)
end

function find_fold_locus(u_slow, p::SBLParams; q_theta = 0.0, e_bounds = (1e-4, 10.0), maxiter = 64)
    q_theta_T = convert(eltype(u_slow), q_theta)
    left, right = e_bounds
    f_left = _fold_determinant(left, q_theta_T, u_slow, p)
    f_right = _fold_determinant(right, q_theta_T, u_slow, p)
    if sign(f_left) == sign(f_right)
        return SVector((left + right) / 2, q_theta_T)
    end

    for _ in 1:maxiter
        mid = (left + right) / 2
        f_mid = _fold_determinant(mid, q_theta_T, u_slow, p)
        if f_mid == 0
            return SVector(mid, q_theta_T)
        elseif sign(f_mid) == sign(f_left)
            left = mid
            f_left = f_mid
        else
            right = mid
            f_right = f_mid
        end
    end

    mid = (left + right) / 2
    return SVector(mid, q_theta_T)
end

function delta_sensitivity_check(u_slow, params::SBLParams, delta_range)
    reference_fold = find_fold_locus(u_slow, params)
    reference_norm = max(norm(reference_fold), eps(eltype(reference_fold)))
    max_shift = zero(eltype(reference_fold))
    for delta_value in delta_range
        perturbed = SBLParams(
            z1 = params.z1,
            z0m = params.z0m,
            z0h = params.z0h,
            d = params.d,
            ell_inf = params.ell_inf,
            kappa = params.kappa,
            cm = params.cm,
            cw = params.cw,
            ctheta = params.ctheta,
            Ctheta = params.Ctheta,
            delta = delta_value,
            g = params.g,
            theta0 = params.theta0,
            Cs = params.Cs,
            kg = params.kg,
            dg = params.dg,
            kappag = params.kappag,
            rho = params.rho,
            cp = params.cp,
            h_min = params.h_min,
            L_e = params.L_e,
            eps1 = params.eps1,
            eps2 = params.eps2,
            eps_strat = params.eps_strat,
        )
        fold = find_fold_locus(u_slow, perturbed)
        shift = norm(fold - reference_fold) / reference_norm
        max_shift = max(max_shift, shift)
    end
    return max_shift
end