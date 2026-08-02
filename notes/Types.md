```julia
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
    h_min::T
    L_e::T
    eps1::T
    eps2::T
end

function SBLParams(;
    z1 = 10.0, z0m = 0.1, z0h = 0.01, d = 0.0, ell_inf = 30.0, kappa = 0.4,
    cm = 0.2, cw = 0.1, ctheta = 0.05, Ctheta = 0.1, delta = 1e-6, g = 9.81, theta0 = 300.0,
    Cs = 1.0, kg = 1.0, dg = 0.1, kappag = 1.0, rho = 1.2, cp = 1004.0, h_min = 10.0,
    L_e = 50.0, eps1 = 0.01, eps2 = 0.1
)
    T = promote_type(
        typeof(z1), typeof(z0m), typeof(z0h), typeof(d), typeof(ell_inf), typeof(kappa),
        typeof(cm), typeof(cw), typeof(ctheta), typeof(Ctheta), typeof(delta), typeof(g),
        typeof(theta0), typeof(Cs), typeof(kg), typeof(dg), typeof(kappag), typeof(rho),
        typeof(cp), typeof(h_min), typeof(L_e), typeof(eps1), typeof(eps2)
    )
    return SBLParams{T}(
        T(z1), T(z0m), T(z0h), T(d), T(ell_inf), T(kappa), T(cm), T(cw), T(ctheta),
        T(Ctheta), T(delta), T(g), T(theta0), T(Cs), T(kg), T(dg), T(kappag), T(rho), T(cp),
        T(h_min), T(L_e), T(eps1), T(eps2)
    )
end

# Explicit scalar type conversion constructor (e.g., SBLParams(Float32; ...))
function SBLParams(::Type{T}; kwargs...) where {T<:Real}
    p = SBLParams(; kwargs...)
    return SBLParams{T}(
        T(p.z1), T(p.z0m), T(p.z0h), T(p.d), T(p.ell_inf), T(p.kappa), T(p.cm), T(p.cw),
        T(p.ctheta), T(p.Ctheta), T(p.delta), T(p.g), T(p.theta0), T(p.Cs), T(p.kg),
        T(p.dg), T(p.kappag), T(p.rho), T(p.cp), T(p.h_min), T(p.L_e), T(p.eps1), T(p.eps2)
    )
end

```

### Key Highlights

* **Autodiff Compatibility:** Automatic promotion via `promote_type` ensures dual numbers pass through without manual casting.
* **Explicit Precision Control:** The added `SBLParams(Float32)` outer method allows easy type casting (e.g., for single-precision GPU or WRF couplings) without overriding all default keyword arguments.