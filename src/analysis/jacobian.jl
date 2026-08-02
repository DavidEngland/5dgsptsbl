function fast_jacobian(u_fast, u_slow, p::SBLParams)
    return ForwardDiff.jacobian(v -> fast_2d_rhs(v, u_slow, p), u_fast)
end

function jacobian_determinant(u_fast, u_slow, p::SBLParams)
    J = fast_jacobian(u_fast, u_slow, p)
    return J[1, 1] * J[2, 2] - J[1, 2] * J[2, 1]
end

function _fold_determinant(e_tilde, u_slow, p::SBLParams)
    return jacobian_determinant(SVector(e_tilde, zero(e_tilde)), u_slow, p)
end

function find_fold_locus(u_slow, p::SBLParams; e_bounds = (1e-4, 10.0), maxiter = 64)
    left, right = e_bounds
    f_left = _fold_determinant(left, u_slow, p)
    f_right = _fold_determinant(right, u_slow, p)
    if sign(f_left) == sign(f_right)
        return SVector((left + right) / 2, zero(left + right))
    end

    for _ in 1:maxiter
        mid = (left + right) / 2
        f_mid = _fold_determinant(mid, u_slow, p)
        if f_mid == 0
            return SVector(mid, zero(mid))
        elseif sign(f_mid) == sign(f_left)
            left = mid
            f_left = f_mid
        else
            right = mid
            f_right = f_mid
        end
    end

    mid = (left + right) / 2
    return SVector(mid, zero(mid))
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
        )
        fold = find_fold_locus(u_slow, perturbed)
        shift = norm(fold - reference_fold) / reference_norm
        max_shift = max(max_shift, shift)
    end
    return max_shift
end