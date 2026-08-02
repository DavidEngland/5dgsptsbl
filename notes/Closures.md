**You should use hyperbolic embedding (smooth max).**

While `max(0, x)` is physically intuitive, using it in GSPT and implicit ODE integration introduces non-smoothness ($C^0$ piecewise continuity with a kink at $x = 0$) that degrades numeric performance and theoretical guarantees.

---

### Why `max` causes issues

1. **GSPT & Fenichel Smoothness Breaking:** Fenichel's Theorem requires the vector field to be $C^r$ smooth ($r \ge 2$). `max(0, x)` has a discontinuous first derivative at $T_s = \theta_0$, introducing artificial kink dynamics into the critical manifold $\mathcal{M}_0$.
2. **Implicit Solver Stalls (`Rodas5P`):** When crossing neutral stratification ($T_s = \theta_0$), adaptive step-size integrators detect the slope jump as a local error spike, causing step-size collapses and Newton iteration retries.
3. **Autodiff Jacobian Discontinuities:** `ForwardDiff` computes step derivatives. A hard switch at $0$ yields derivative jumps ($0 \to 1$) in $J_{\text{fast}}$, causing root-finders like fold-locus trackers to fail near neutral stability.

---

### Hyperbolic Embedding (Algebraic Smooth Max)

An algebraic hyperbolic embedding provides a $C^\infty$ smooth approximation without the computational expense or overflow risk of exponential softplus ($\log(1 + e^{x/\epsilon})$):

$$f_\epsilon(x) = \frac{x + \sqrt{x^2 + \epsilon^2}}{2}$$

* **As $x \to \infty$:** $f_\epsilon(x) \sim x$
* **As $x \to -\infty$:** $f_\epsilon(x) \sim 0$
* **At $x = 0$:** $f_\epsilon(0) = \frac{\epsilon}{2}$

---

### Updated Code Implementation

Add a smoothing scale parameter `eps_strat` (e.g., $10^{-4}$ or $10^{-6}$) to `SBLParams` and update `stratification`:

```julia
# src/physics/closures.jl

"""
    smooth_max(x, eps)

C^infty algebraic hyperbolic embedding approximation of max(0, x).
"""
@inline function smooth_max(x, eps)
    return 0.5 * (x + sqrt(x^2 + eps^2))
end

@inline function stratification(Ts, e_tilde, params::SBLParams)
    raw_grad = (params.theta0 - Ts) / h_sbl(e_tilde, params)
    # Replaces hard max(0, raw_grad) with smooth hyperbolic embedding
    return smooth_max(raw_grad, params.eps_strat)
end

@inline function theta_z(Ts, e_tilde, params::SBLParams)
    return stratification(Ts, e_tilde, params)
end

```

### Parameter Struct Update

Add `eps_strat` to `SBLParams` in `src/types.jl`:

```julia
# src/types.jl
struct SBLParams{T<:Real}
    # ... existing fields ...
    eps_strat::T
end

function SBLParams(;
    # ... existing kwargs ...,
    eps_strat = 1e-4
)
    # Include eps_strat in promote_type and struct constructor
end

```