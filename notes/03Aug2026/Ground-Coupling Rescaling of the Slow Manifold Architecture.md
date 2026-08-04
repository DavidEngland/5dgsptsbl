## Ground-Coupling Rescaling of the Slow Manifold Architecture  
**1. Ground-Flux Ratio and Sign Convention**  
To incorporate conductive soil thermal coupling without introducing site-specific soil properties (such as moisture-dependent conductivity k_g or skin thickness d_g), ground heat transfer is expressed relative to net radiative forcing via the nondimensional ground-flux ratio \Pi_G.  
Under nocturnal conditions, net radiation acts as a surface heat sink (R_{\text{net}} < 0). We define upward ground heat flux into the skin layer as positive (G > 0, warming the skin). The ground-flux ratio is defined as:  
```
\Pi_G = \frac{-G}{R_{\text{net}}(T_s)}

```
Because both -G < 0 and R_{\text{net}} < 0 during typical nighttime cooling with upward soil heat supply, \Pi_G > 0. Rearranging this expression yields the exact flux substitution:  
```
G = -\Pi_G R_{\text{net}}(T_s)

```
Normalizing ground heat transfer by R_{\text{net}} eliminates direct parameterization of subsoil thermal conductivity and layer depth, yielding a dimensionless coupling parameter that isolates the dynamic effect of subsurface heat supply on surface energy dynamics.  
**2. Derivation of the Effective Surface Heat Capacity**  
The skin temperature evolution is governed by the surface energy balance (SEB):  
```
C_s \frac{dT_s}{dt} = R_{\text{net}}(T_s) + G + H

```
where C_s is the physical heat capacity of the skin layer and H is the sensible turbulent heat flux. Substituting G = -\Pi_G R_{\text{net}}(T_s) into the energy balance gives:  
```
C_s \frac{dT_s}{dt} = R_{\text{net}}(T_s) - \Pi_G R_{\text{net}}(T_s) + H = (1 - \Pi_G) R_{\text{net}}(T_s) + H

```
Dividing both sides by the coupling factor (1 - \Pi_G) isolates the driving radiative and turbulent forcing terms:  
```
\left( \frac{C_s}{1 - \Pi_G} \right) \frac{dT_s}{dt} = R_{\text{net}}(T_s) + \frac{H}{1 - \Pi_G}

```
This defines the effective surface heat capacity:  
```
C_s^{\text{eff}} = \frac{C_s}{1 - \Pi_G}

```
**Note:** Equation C_s^{\text{eff}} = \frac{C_s}{1 - \Pi_G} is an exact algebraic identity derived directly from the surface energy balance, not a heuristic approximation.  
**3. Rescaling of the Slow Thermal Timescale**  
The local thermal response time of the surface skin layer \tau_s is determined by the ratio of its effective heat capacity to the linearized radiative cooling feedback:  
```
\tau_s = \frac{C_s^{\text{eff}}}{\lambda_R}

```
where \lambda_R = \left\vert{} \frac{\partial R_{\text{net}}}{\partial T_s} \right\vert{} represents the linearized radiative feedback factor. Substituting the expression for C_s^{\text{eff}} yields:  
```
\tau_s(\Pi_G) = \frac{C_s}{\lambda_R (1 - \Pi_G)} = \frac{\tau_{s,0}}{1 - \Pi_G}

```
where \tau_{s,0} = \frac{C_s}{\lambda_R} is the uncoupled surface thermal response time (\Pi_G = 0). Consequently, the ground-coupling parameter directly rescales the surface thermal evolution timescale:  
```
\tau_s \propto \frac{1}{1 - \Pi_G}

```
**4. Modification of the Singular Perturbation Parameter**  
In the Geometric Singular Perturbation Theory (GSPT) formulation of the stable boundary layer, the fundamental non-dimensional parameter governing timescale separation is the ratio of fast turbulent relaxation \tau_{\text{turb}} to slow surface thermal evolution \tau_s:  
```
\varepsilon = \frac{\tau_{\text{turb}}}{\tau_s}

```
Substituting the ground-rescaled surface timescale \tau_s(\Pi_G) into this definition yields:  
```
\varepsilon(\Pi_G) = \frac{\tau_{\text{turb}}}{\left( \frac{\tau_{s,0}}{1 - \Pi_G} \right)} = \left( \frac{\tau_{\text{turb}}}{\tau_{s,0}} \right) (1 - \Pi_G)

```
Defining \varepsilon_0 = \frac{\tau_{\text{turb}}}{\tau_{s,0}} as the baseline singular perturbation parameter in the absence of ground coupling, we obtain:  
```
\varepsilon(\Pi_G) = \varepsilon_0 (1 - \Pi_G)

```
This scaling relationship demonstrates that ground heat transfer directly modulates the fast-slow timescale separation parameter \varepsilon, rather than acting as a simple surface boundary forcing.  
**5. Geometric Interpretation**  
Under Fenichel's Theorem, normal hyperbolicity and the existence of an attracting slow manifold \mathcal{M}_\varepsilon require a distinct separation of timescales (\varepsilon \ll 1). The rescaled perturbation parameter \varepsilon(\Pi_G) dictates the dynamic stability and speed of state trajectories along this manifold:  
* **Strong Timescale Separation (\Pi_G \to 1^-):** Increasing \Pi_G reduces \varepsilon(\Pi_G) \to 0. This strengthens the validity of the Fenichel slow manifold, holding trajectories tightly to the attracting branch. Radiative cooling is largely offset by subsurface conduction, slowing trajectory evolution along the slow manifold and delaying or preventing approach to the non-hyperbolic fold locus \mathcal{C}_{\text{fold}}.  
* **Reduced Timescale Separation (\Pi_G \le 0):** Unbuffered or insulating surfaces leave \varepsilon(\Pi_G) \ge \varepsilon_0. The loss of ground buffering accelerates motion along the slow manifold, allowing surface temperature to cool rapidly and driving system trajectories quickly toward \mathcal{C}_{\text{fold}}, where normal hyperbolicity breaks down and turbulent collapse occurs.  
**6. Three Dynamical Regimes**  
The impact of ground coupling on the phase space geometry is classified into three distinct physical regimes:  

| Regime | Ground-Flux Ratio | Effective Heat Capacity | GSPT Dynamic Consequence |
| ------------------ | ----------------- | ------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Weak Buffering | \\Pi_G \\le 0 | C_s^{\\text{eff}} \\le C_s | Accelerated cooling along slow manifold; rapid approach to fold locus \\mathcal{C}_{\\text{fold}} and heightened risk of turbulent collapse (e.g., Arctic sea ice, dry sand). |
| Moderate Buffering | 0 < \\Pi_G < 1 | C_s^{\\text{eff}} > C_s | Lengthened thermal timescale \\tau_s; stabilized motion along attracting manifold \\mathcal{M}_\\varepsilon, delaying transition (e.g., vegetated grassland, moist soil). |
| Strong Buffering | \\Pi_G \\to 1^- | C_s^{\\text{eff}} \\to \\infty | Asymptotic limit (\\varepsilon \\to 0); ground supply balances radiative deficit (G \\approx -R_{\\text{net}}), making \\mathcal{C}_{\\text{fold}} physically unreachable on finite timescales. |
  
**7. Connection to the Critical Richardson Number**  
The ground-coupling scaling \varepsilon(\Pi_G) = \varepsilon_0(1 - \Pi_G) provides a geometric explanation for observed variations in the critical Richardson number (Ri_c) across field sites.  
Empirical variations in threshold behavior between sites (such as grassland versus sea ice) do not necessarily reflect non-universal turbulent closure dynamics. Instead, site-specific soil thermodynamics map onto \Pi_G, directly altering the fast-slow parameter \varepsilon. Ground coupling modulates the rate of evolution along the attracting slow manifold and changes where trajectories encounter the folded critical manifold \mathcal{C}_{\text{fold}}.  
Consequently, apparent variability in Ri_c emerges as a low-dimensional projection of ground-coupling modulation on slow-manifold geometry, rather than a failure of unified boundary layer scaling theory.  
