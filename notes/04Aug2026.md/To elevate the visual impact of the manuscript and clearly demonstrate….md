To elevate the visual impact of the manuscript and clearly demonstrate the power of the 5D Geometric Singular Perturbation Theory (GSPT) framework, here are three high-impact, publication-ready figure concepts designed to showcase the paper's core mathematical and physical breakthroughs.  
## High-Impact Figure Concepts  
**1. The Geometric Origin of Ri_{\text{crit}} Dispersion**  
* **The Concept:** A 3D phase-space diagram illustrating how scalar Richardson level sets intersect the 2D fold manifold \mathcal{C}_{\text{fold}}.  
* **Why It’s "Awesome":** Visually proves the main thesis of the paper: observed campaign scatter (0.2 \le Ri_{\text{crit}} \le 1.0) is a rank-1 geometric projection artifact of \pi_{Ri}, not a failure of fluid mechanics.  
* **Panels / Elements:**  
    * **3D Surface:** Fold set \mathcal{C}_{\text{fold}} mapped in (\tilde{e}, q_\theta, S) coordinates.  
    * **Intersecting Foliation:** Translucent Ri = 0.2 and Ri = 0.25 constant surfaces slicing through \mathcal{C}_{\text{fold}}.  
    * **Campaign Trajectories:** Superimposed simulated trajectories corresponding to **CASES-99** (grassland, moderate \Pi_G) vs. **SHEBA** (Arctic sea ice, low \Pi_G), showing where each crosses the fold line at distinct Ri values.  
**2. Subsurface Ground-Coupling (\Pi_G) Regime Sweep**  
* **The Concept:** A 4-panel bifurcation and trajectory plot demonstrating the analytical scaling relation \varepsilon(\Pi_G) = \varepsilon_0 (1 - \Pi_G).  
* **Why It’s "Awesome":** Direct numerical proof of how soil heat capacity alters timescale separation and delays or suppresses turbulence collapse.  
* **Panels:**  
    * **Panel (a):** T_s(t) evolution across ground-coupling ratios \Pi_G \in \{0.0, 0.3, 0.6, 0.9\}.  
    * **Panel (b):** TKE trajectories \tilde{e}(t) showing collapse delay as \Pi_G \to 1^-.  
    * **Panel (c):** Phase portrait (\tilde{e}, T_s) showing trajectory deceleration along the slow manifold \mathcal{M}_\varepsilon.  
    * **Panel (d):** Critical shear threshold S_{\text{fold}}(\Pi_G) curve separating collapse vs. sustained-turbulence regimes.  
**3. Folding Geometry & Canard "Turbulence Whispering"**  
* **The Concept:** A high-resolution phase-plane projection near the fold boundary \mathcal{C}_{\text{fold}}.  
* **Why It’s "Awesome":** Highlights pre-collapse oscillations and trajectory funneling along folded singularity curves before fast-scale ejection.  
* **Panels / Elements:**  
    * Vector field arrows of the desingularized fast system (\dot{\tilde{e}}, \dot{q}_\theta) on \tau.  
    * Parabolic critical manifold \mathcal{M}_0 with green attracting branch \mathcal{M}_0^+ and red repelling branch \mathcal{M}_0^-.  
    * Trajectory bundle showing slow passage through the non-hyperbolic fold zone.  
## Julia Figure Generation Script Template  
Below is a Julia script outline using Plots.jl (or CairoMakie.jl) that can be saved to scripts/plot_ground_coupling_sweep.jl to generate the multi-panel \Pi_G regime sweep figure at **300 DPI**:  
```
#!/usr/bin/env julia
# scripts/plot_ground_coupling_sweep.jl

using Plots
using DifferentialEquations
using Measures

# Load project closures and system definitions
include("../src/physics/closures.jl")
include("../src/physics/system.jl")

function run_pi_g_sweep()
    pyplot() # or gr()
    
    pi_g_values = [0.0, 0.25, 0.50, 0.75, 0.90]
    colors = [:crimson, :darkorange, :goldenrod, :seagreen, :navy]
    
    p1 = plot(xlabel="Time [hr]", ylabel="TKE \\tilde{e} [m^{1/2} s^{-1/2}]", title="(a) Turbulence Collapse Delay")
    p2 = plot(xlabel="Time [hr]", ylabel="Skin Temperature T_s [K]", title="(b) Surface Thermal Response")
    p3 = plot(xlabel="T_s [K]", ylabel="\\tilde{e}", title="(c) Slow Manifold Trajectories")
    
    for (i, \Pi_G) in enumerate(pi_g_values)
        # 1. Update parameter struct with modified ground coupling / effective capacity
        params = SBLParams(Pi_G = \Pi_G)
        
        # 2. Integrate ODE system
        prob = ODEProblem(sbl_fast_slow_system!, x0, (0.0, 43200.0), params)
        sol = solve(prob, Rodas5P(), reltol=1e-8, abstol=1e-8)
        
        # 3. Extract time series
        t_hr = sol.t ./ 3600.0
        e_tilde = sol[1, :]
        T_s = sol[4, :]
        
        # 4. Plot curves
        plot!(p1, t_hr, e_tilde, label="\\Pi_G = $(\Pi_G)$", color=colors[i], lw=2)
        plot!(p2, t_hr, T_s, label="\\Pi_G = $(\Pi_G)$", color=colors[i], lw=2)
        plot!(p3, T_s, e_tilde, label="\\Pi_G = $(\Pi_G)$", color=colors[i], lw=2)
    end
    
    # Assemble multi-panel graphic
    final_fig = plot(p1, p2, p3, layout=(1, 3), size=(1200, 380), margin=5mm)
    
    output_path = "paper/figures/ground_coupling_sweep.png"
    savefig(final_fig, output_path)
    println("Saved high-res figure to ", output_path)
end

run_pi_g_sweep()

```
Which of these figure concepts would you like to build out and integrate into results_figures.tex.mustache first?  
