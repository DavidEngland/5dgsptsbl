Given the stage of your project, I would draft the manuscript subsection first.  
The reason is that you’ve now identified a result that is more than a numerical convenience—it is a structural property of the GSPT formulation. Once that theoretical statement is fixed, the Julia implementation becomes almost mechanical.  
I would organize the subsection something like this:  
1. **Ground-Flux Ratio and Sign Convention**
2. **Ground-Flux Ratio and Sign Convention**
    * Define the nighttime sign convention (R_{\text{net}}<0, upward G>0).  
    * Introduce\Pi_G=\frac{-G}{R_{\text{net}}}.
    * Explain why this normalization removes dependence on uncertain soil conductivity and layer depth while retaining the dynamically relevant physics.  
3. **Derivation of the Effective Surface Heat Capacity**  
4. **Derivation of the Effective Surface Heat Capacity**  
    * DeriveC_s^{\rm eff}=\frac{C_s}{1-\Pi_G}directly from the surface energy balance.
    * Emphasize that this is an exact algebraic reformulation under the stated definition of \Pi_G, not an approximation.  
5. **Rescaling of the Slow Thermal Timescale**  
    * Introduce the thermal response time\tau_s=\frac{C_s^{\rm eff}}{\partial R_{\rm net}/\partial T_s},or an equivalent local linearization.
    * Show immediately that\tau_s\propto\frac{1}{1-\Pi_G}.
6. **Modification of the Singular Perturbation Parameter**  
    * Recall the fast–slow parameter\varepsilon=\frac{\tau_{\rm turb}}{\tau_s}.
    * Substituting the previous result gives\varepsilon(\Pi_G)=\varepsilon_0(1-\Pi_G),where\varepsilon_0=\frac{\tau_{\rm turb}}{\tau_{s,0}}is the uncoupled value.
7. This equation is, in my view, the key theoretical contribution of the subsection because it shows that ground coupling directly modulates the fast–slow timescale separation rather than merely altering the surface energy budget.
8. **Geometric Interpretation**  
    * Explain that increasing \Pi_G decreases \varepsilon, strengthening the validity of the Fenichel slow manifold and delaying approach to \mathcal C_{\rm fold}.  
    * Conversely, insulating surfaces leave \varepsilon larger, reducing scale separation and allowing trajectories to reach the fold more rapidly.  
9. **Three Dynamical Regimes**Present a concise table:
10. **Three Dynamical Regimes**Present a concise table:
  

| Regime | \\Pi_G | C_s^{\\rm eff} | GSPT consequence |
| ------------------ | ----------------------- | --------------------------------- | ------------------------------------------------- |
| Weak buffering | \\Pi_G\\le0 | C_s^{\\rm eff}\\le C_s | Fast surface cooling, earlier fold encounter |
| Moderate buffering | 0<\\Pi_G<1 | C_s^{\\rm eff}>C_s | Slower evolution along attracting slow manifold |
| Strong buffering | \\Pi_G\\rightarrow1^{-} | C_s^{\\rm eff}\\rightarrow\\infty | Fold effectively unreachable on finite timescales |
  
7. **Connection to the Richardson Number**Conclude by tying this back to the central thesis of Paper 1:The observed variability of the critical Richardson number is not solely a consequence of turbulent closure or atmospheric forcing. Ground coupling modifies the singular perturbation parameter through \Pi_G, thereby changing the rate at which trajectories evolve along the attracting slow manifold and determining where they intersect the folded critical manifold. Consequently, apparent variability in Ri_c emerges as a projection of differing manifold geometries rather than evidence against a unified dynamical framework.
8. **Connection to the Richardson Number**Conclude by tying this back to the central thesis of Paper 1:The observed variability of the critical Richardson number is not solely a consequence of turbulent closure or atmospheric forcing. Ground coupling modifies the singular perturbation parameter through \Pi_G, thereby changing the rate at which trajectories evolve along the attracting slow manifold and determining where they intersect the folded critical manifold. Consequently, apparent variability in Ri_c emerges as a projection of differing manifold geometries rather than evidence against a unified dynamical framework.
One suggestion regarding the supervisor weighting: rather than introducing it in Paper 1, I would reserve it for the modeling or parameterization paper. Paper 1 is strongest if it establishes the geometric theory and observational interpretation without introducing implementation-specific control logic. Then Paper 2 can naturally build on this result by showing how \Pi_G-dependent scaling informs a dynamically adaptive SCM parameterization. That separation keeps the theoretical narrative focused while providing a clear bridge to the modeling work.  
