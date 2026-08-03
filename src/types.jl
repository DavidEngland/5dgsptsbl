#!/usr/bin/env julia
# src/types.jl
struct SBLParams{T<:Real}
    z1::T
    z0m::T
    z0h::T
    d::T
    ell_inf::T
    kappa::T
    cm::T
    cw::T
    ctheta::T
    Ctheta::T
    delta::T
    g::T
    theta0::T
    Cs::T
    kg::T
    dg::T
    kappag::T
    rho::T
    cp::T
    S_geo::T
    tau_S::T
    R_down::T
    emissivity::T
    h_min::T
    L_e::T
    eps1::T
    eps2::T
    eps_strat::T
end

function SBLParams(; z1 = 10.0, z0m = 0.1, z0h = 0.01, d = 0.0, ell_inf = 30.0, kappa = 0.4,
    cm = 0.2, cw = 0.1, ctheta = 0.05, Ctheta = 0.1, delta = 1e-6, g = 9.81, theta0 = 300.0,
    Cs = 1.0, kg = 1.0, dg = 0.1, kappag = 1.0, rho = 1.2, cp = 1004.0,
    S_geo = 0.05, tau_S = 3600.0, R_down = 250.0, emissivity = 0.98, h_min = 10.0,
    L_e = 50.0, eps1 = 0.01, eps2 = 0.1, eps_strat = 1e-4)
    T = promote_type(typeof(z1), typeof(z0m), typeof(z0h), typeof(d), typeof(ell_inf), typeof(kappa),
        typeof(cm), typeof(cw), typeof(ctheta), typeof(Ctheta), typeof(delta), typeof(g),
        typeof(theta0), typeof(Cs), typeof(kg), typeof(dg), typeof(kappag), typeof(rho),
        typeof(cp), typeof(S_geo), typeof(tau_S), typeof(R_down), typeof(emissivity), typeof(h_min),
        typeof(L_e), typeof(eps1), typeof(eps2), typeof(eps_strat))
    return SBLParams{T}(T(z1), T(z0m), T(z0h), T(d), T(ell_inf), T(kappa), T(cm), T(cw), T(ctheta),
        T(Ctheta), T(delta), T(g), T(theta0), T(Cs), T(kg), T(dg), T(kappag), T(rho), T(cp),
        T(S_geo), T(tau_S), T(R_down), T(emissivity), T(h_min), T(L_e), T(eps1), T(eps2), T(eps_strat))
end

function SBLParams(::Type{T}; kwargs...) where {T<:Real}
    p = SBLParams(; kwargs...)
    return SBLParams{T}(T(p.z1), T(p.z0m), T(p.z0h), T(p.d), T(p.ell_inf), T(p.kappa), T(p.cm),
        T(p.cw), T(p.ctheta), T(p.Ctheta), T(p.delta), T(p.g), T(p.theta0), T(p.Cs), T(p.kg),
        T(p.dg), T(p.kappag), T(p.rho), T(p.cp), T(p.S_geo), T(p.tau_S), T(p.R_down),
        T(p.emissivity), T(p.h_min), T(p.L_e), T(p.eps1), T(p.eps2), T(p.eps_strat))
end

function SBLParams(preset::Symbol; kwargs...)
    base = if preset == :cases99
        (; cm = 0.048, cw = 0.029, ctheta = 0.021, Ctheta = 0.052, ell_inf = 38.5)
    elseif preset == :sheba
        (; cm = 0.031, cw = 0.018, ctheta = 0.035, Ctheta = 0.078, ell_inf = 12.4)
    else
        throw(ArgumentError("Unknown SBLParams preset: $preset"))
    end
    return SBLParams(; base..., kwargs...)
end