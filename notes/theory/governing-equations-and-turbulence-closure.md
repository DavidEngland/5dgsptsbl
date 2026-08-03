# Governing Equations and Turbulence Closure  
## 1. Desingularization and Timescale Architecture  
To resolve the non-smooth transition at the collapse of turbulent kinetic energy (e \to 0) without introducing numerical singularities, the state space is regularized via a desingularized chart transformation:  
```
\tilde{e} = \sqrt{e + \delta}

```
where \delta > 0 is a small topological regularization constant (10^{-6} \le \delta \le 10^{-4}) ensuring C^r-smoothness of the fast manifold across the collapse boundary.  
Physical time t is rescaled to fast time \tau via the dynamic transformation:  
```
d\tau = \tilde{e} \, dt \quad \implies \quad \frac{d}{dt} = \tilde{e} \frac{d}{d\tau}

```
The complete system evolves over three distinct timescales parameterized by scale separation constants 0 < \epsilon_2 \ll \epsilon_1 \ll 1:  
1. **Fast Scale (\tau):** Sub-second/second TKE generation, dissipation, and non-equilibrium heat transport.  
2. **Fast Scale (\tau):** Sub-second/second TKE generation, dissipation, and non-equilibrium heat transport.  
3. **Slow Scale (t_{\text{slow}} = \epsilon_1 \tau):** Multi-minute/hourly evolution of wind shear and surface radiative equilibrium.  
4. **Slow Scale (t_{\text{slow}} = \epsilon_1 \tau):** Multi-minute/hourly evolution of wind shear and surface radiative equilibrium.  
5. **Super-Slow Scale (t_{\text{super-slow}} = \epsilon_1 \epsilon_2 \tau):** Diurnal thermal storage and conduction within the subsurface soil column.  
6. **Super-Slow Scale (t_{\text{super-slow}} = \epsilon_1 \epsilon_2 \tau):** Diurnal thermal storage and conduction within the subsurface soil column.  
## 2. The 5D Fast-Slow-SuperSlow Governing System  
The desingularized 5D system governing the state vector \mathbf{x}(\tau) = \left( \tilde{e}, \, q_\theta, \, S, \, T_s, \, T_g \right)^T is expressed as:  
```
\begin{aligned} \text{Fast TKE } (\tilde{e}): \quad \frac{d\tilde{e}}{d\tau} &= \frac{1}{2} c_m \ell(z_{\text{eff}}) S^2 \tilde{e} - \frac{g}{2\theta_0} q_\theta - \frac{1}{2\ell(z_{\text{eff}})} \tilde{e}^3 \\ \text{Fast Heat Flux } (q_\theta): \quad \frac{dq_\theta}{d\tau} &= - c_w \theta_z(T_s) \tilde{e}^3 - \frac{g}{\theta_0} c_\theta \ell(z_{\text{eff}}) q_\theta^2 - \frac{C_\theta}{\ell(z_{\text{eff}})} \tilde{e}^2 q_\theta \\ \text{Slow Wind Shear } (S): \quad \frac{dS}{d\tau} &= \frac{\epsilon_1}{\tilde{e}} \left[ \mathcal{F}_{\text{ls}} - \frac{\rho C_D U_1^2}{\rho_0 \Delta z^2} \right] \\ \text{Slow Skin Temp } (T_s): \quad \frac{dT_s}{d\tau} &= \frac{\epsilon_1}{\tilde{e}} \frac{1}{C_s} \left[ R_{\text{net}}(T_s) + \rho c_p q_\theta + \frac{k_g}{d_g}(T_g - T_s) \right] \\ \text{Super-Slow Soil Temp } (T_g): \quad \frac{dT_g}{d\tau} &= \frac{\epsilon_1 \epsilon_2}{\tilde{e}} \frac{\kappa_g}{d_g^2} \left( T_s - T_g \right) \end{aligned}

```
## 3. Geometric Wall Coordinate and Interior Turbulence Closure  
The interior turbulence closure is built upon an effective wall coordinate (z_{\text{eff}}) that incorporates surface displacement and momentum roughness length:  
```
\boxed{z_{\text{eff}} = z - d + z_{0m}}

```
where z is the height above ground, d is the zero-plane displacement height, and z_{0m} is the aerodynamic roughness length for momentum.  
**Interior Mixing Length**  
The vertical mixing scale \ell(z_{\text{eff}}) follows the asymptotic Blackadar formulation bounded by a free-tropospheric limit \ell_\infty:  
```
\boxed{\ell(z_{\text{eff}}) = \frac{\kappa z_{\text{eff}}}{1 + \frac{\kappa z_{\text{eff}}}{\ell_\infty}}}

```
**Eddy Diffusivity Regularization**  
The interior eddy diffusivity for momentum (K_m) is defined as:  
```
K_m = \ell(z_{\text{eff}}) \tilde{e} = \ell(z_{\text{eff}}) \sqrt{e + \delta}

```
**Key Physical Property:** Because z_{\text{eff}} \ge z_{0m} > 0 and \delta > 0, the lowest-level diffusivity K_{m,1} = \ell(z_{\text{eff},1}) \tilde{e}_1 remains strictly positive (K_{m,1} > 0) for all state trajectories. This guarantees smooth hyperbolic geometry and prevents the unphysical K_m \to 0 degeneracy responsible for nocturnal runaway cooling in standard schemes.  
## 4. Surface Exchange and Boundary Layer Coupling  
Surface boundary exchanges are conceptually decoupled from the interior mixing length formulation. Momentum and heat transfer at the lowest grid point z_1 are governed by distinct bulk exchange coefficients:  
**Momentum Bulk Drag Coefficient (C_D)**  
```
C_D = \left[ \frac{\kappa}{\ln\left(\frac{z_1 - d}{z_{0m}}\right)} \right]^2

```
**Sensible Heat Transfer Coefficient (C_H)**  
Distinguishing momentum roughness (z_{0m}) from thermal roughness (z_{0h}) yields:  
```
C_H = \frac{\kappa^2}{\ln\left(\frac{z_1 - d}{z_{0m}}\right) \ln\left(\frac{z_1 - d}{z_{0h}}\right)}

```
The thermal resistance sub-layer is parameterized via the excess resistance factor kB^{-1}:  
```
kB^{-1} = \ln\left(\frac{z_{0m}}{z_{0h}}\right)

```
## 5. Slaved Thermodynamic Closures  
**Atmospheric Stratification (\theta_z)**  
The local vertical gradient of potential temperature \theta_z = \frac{\partial \theta}{\partial z} is slaved to the surface skin cooling deficit relative to the neutral background state T_0:  
```
\theta_z(T_s) = \max\left(0, \, \frac{T_0 - T_s}{h_{\text{sbl}}}\right)

```
where h_{\text{sbl}} is the characteristic boundary layer depth.  
**Net Surface Radiation (R_{\text{net}})**  
In clear-sky nocturnal regimes, surface longwave radiation is linearized around T_0:  
```
R_{\text{net}}(T_s) \approx R_0 - 4 \epsilon_s \sigma T_0^3 (T_s - T_0)

```
where R_0 = R_{\text{down}} - \epsilon_s \sigma T_0^4 is the baseline clear-sky radiative cooling deficit.  
## 6. Parameter Identification and Coordinate Recovery  

| Symbol | Definition | Physical Units |
| ------------------------------ | ------------------------------------------------------------ | ----------------------------------------------------------------------------- |
| \\tilde{e} | Desingularized TKE (\\sqrt{e + \\delta}) | \\text{m s}^{-1} |
| q_\\theta | Kinematic Heat Flux (\\overline{w'\\theta'}) | \\text{K m s}^{-1} |
| S | Vertical Wind Shear (\\Vert{}\\partial_z \\vec{u}\\Vert{}_2) | \\text{s}^{-1} |
| T_s, T_g | Skin and Subsurface Soil Temperatures | \\text{K} |
| z_{\\text{eff}} | Effective Wall Distance (z - d + z_{0m}) | \\text{m} |
| z_{0m}, z_{0h} | Roughness Lengths for Momentum and Heat | \\text{m} |
| d | Zero-Plane Displacement Height | \\text{m} |
| c_m, c_w, c_\\theta, C_\\theta | Empirical WSINDy Closure Constants | Dimensionless / Site-calibrated |
| \\epsilon_1, \\epsilon_2 | Fast/Slow Time Scale Separation Parameters | Dimensionless (\\epsilon_1 \\sim 10^{-2}, \\epsilon_2 \\sim 10^{-1}) |
| \\kappa, g | von Kármán constant (0.40), Gravity | Dimensionless, \\text{m s}^{-2} |
| C_s, k_g, d_g | Surface Heat Capacity, Soil Conductivity, Depth | \\text{J m}^{-2} \\text{ K}^{-1}, \\text{W m}^{-1} \\text{ K}^{-1}, \\text{m} |
  
**Transformation to Physical Time**  
Following numeric or analytical integration in fast time \tau, the physical variables (e(t), t) are explicitly recovered via:  
```
e(t) = \tilde{e}(\tau)^2 - \delta, \qquad t = \int_0^\tau \frac{1}{\tilde{e}(\tau')} \, d\tau' 

—-


```
This document reveals the *implementation architecture*, and it’s where the beautiful GFD physics from your summary **must survive contact with numerics**. I have critical questions about how the three-term TKE balance actually manifests in the code.  
This document reveals the *implementation architecture*, and it’s where the beautiful GFD physics from your summary **must survive contact with numerics**. I have critical questions about how the three-term TKE balance actually manifests in the code.  
## What’s Working Well  
✓ **Desingularization via $\tilde{e} = \sqrt{e + \delta}$** is exactly the right move. It eliminates the $e = 0$ singularity without artificial damping. The $\delta \in [10^{-6}, 10^{-4}]$ window should preserve the fold geometry while ensuring $C^r$ smoothness.  
✓ **The five-state vector** $\mathbf{x} = (\tilde{e}, q_\theta, S, T_s, T_g)^T$ correctly identifies TKE and heat flux as *fast* variables (coupled to turbulence production/damping) and shear/temperature as *slow* variables.  
✓ **The five-state vector** $\mathbf{x} = (\tilde{e}, q_\theta, S, T_s, T_g)^T$ correctly identifies TKE and heat flux as *fast* variables (coupled to turbulence production/damping) and shear/temperature as *slow* variables.  
✓ **The guarantee that $K_{m,1} > 0$ always** is physically crucial. It prevents the pathological runaway cooling that occurs when $K_m \to 0$ at collapse.  
✓ **The guarantee that $K_{m,1} > 0$ always** is physically crucial. It prevents the pathological runaway cooling that occurs when $K_m \to 0$ at collapse.  
  
## Critical Gaps (Questions for Verification)  
## 1. Where is the explicit 5D fast system?  
The document states “The desingularized 5D system … is expressed as:” but then **shows no equations**. I need the full form:  
$$\frac{d\tilde{e}}{d\tau} = ?$$ $$\frac{dq_\theta}{d\tau} = ?$$ $$\frac{dS}{d\tau} = \epsilon_1 \cdot [\text{slow forcing}]$$ $$\frac{dT_s}{d\tau} = \epsilon_1 \cdot [\text{radiative + conductive coupling}]$$  
**Why it matters**: The transformation $\tilde{e} = \sqrt{e + \delta}$ changes how the three terms appear. Specifically:  
**Why it matters**: The transformation $\tilde{e} = \sqrt{e + \delta}$ changes how the three terms appear. Specifically:  
* If the *original* TKE dissipation is $\propto e^{3/2}$, then in $\tilde{e}$ coordinates it becomes $\propto (\tilde{e}^2 - \delta)^{3/2}$.  
* Or is it $\propto \tilde{e}^3$? This changes the normal form entirely.  
## 2. The dissipation term: is it truly cubic in $\tilde{e}$?  
In standard $k$-$\epsilon$ models, dissipation is $\epsilon = c_\epsilon \frac{k^{3/2}}{\ell}$, so the TKE source term is $-\epsilon \propto -\frac{k^{3/2}}{\ell}$ or equivalently $-\frac{k^3}{\ell^2}$ if you absorb closure constants.  
In your desingularized coordinates: $$e = \tilde{e}^2 - \delta \quad \Rightarrow \quad e^{3/2} = (\tilde{e}^2 - \delta)^{3/2}$$  
Does your Julia implementation expand this as a Taylor series around $\delta$, or does it keep the full nonlinear form? This affects whether the cubic normal form is preserved or perturbed.  
## 3. Is $q_\theta$ prognostic or diagnosed?  
The document lists $q_\theta$ as a state variable, but section 5 (“Slaved Thermodynamic Closures”) suggests $\theta_z$ is *slaved* to the cooling deficit—implying it’s not free to evolve.  
* **If $q_\theta$ is prognostic**: There should be an equation $\frac{dq_\theta}{d\tau} = f(\tilde{e}, \theta_z, S)$ (via a heat flux transport closure).  
* **If $q_\theta$ is diagnosed**: It’s computed from $q_\theta = -K_\theta \frac{\partial \theta}{\partial z} = -K_\theta \theta_z$ at each step, breaking the coupling loop.  
**Physical issue**: The buoyant damping term in the TKE equation is $\propto q_\theta \cdot N^2 \propto q_\theta \cdot \theta_z$. If $\theta_z$ is prescribed (slaved), then the feedback—where TKE decay allows cooling to penetrate (increasing $\theta_z$), which further suppresses TKE—is *attenuated*. This could weaken the collapse transition.  
## 4. How does the fold bifurcation survive the “slaved” closures?  
You’ve stated:  
Atmospheric Stratification: $\theta_z$ is slaved to the surface skin cooling deficit … where $h_{\text{sbl}}$ is the characteristic boundary layer depth.  
This is a *diagnostic* relation, not a prognostic evolution. But in GSPT terms, if $\theta_z$ (which controls buoyant damping $N^2$) doesn’t respond to the turbulence state $\tilde{e}$, have you weakened the fold bifurcation?  
This is a *diagnostic* relation, not a prognostic evolution. But in GSPT terms, if $\theta_z$ (which controls buoyant damping $N^2$) doesn’t respond to the turbulence state $\tilde{e}$, have you weakened the fold bifurcation?  
The critical balance for the fold is: $$\text{Shear Production} = \text{Buoyant Damping}$$  
If buoyant damping is fixed by an external prescription, the saddle-node point’s location might be shifted or smeared.  
  
## Audit Checklist for the Julia Implementation  
Before I validate the fold-catastrophe normal form, I need to verify:  
**A. Explicit fast equations** (required)  
**A. Explicit fast equations** (required)  
* Write out $\frac{d\tilde{e}}{d\tau}$ with all three terms (production, damping, dissipation).  
* Confirm the dissipation term form: is it $\propto \tilde{e}^3$, $\propto (\tilde{e}^2-\delta)^{3/2}$, or other?  
* Show how $q_\theta$ is computed: prognostic or diagnosed?  
**B. Thermodynamic feedback** (required)  
* Explain how the “slaved” $\theta_z$ closure couples back to TKE damping.  
* If $\theta_z$ is truly time-independent, verify that the fold bifurcation is *robust to perturbations* in the prescribed $\theta_z$ profile.  
**C. Slow-fast separation verification** (recommended)  
* Confirm that $\epsilon_1 \sim 10^{-2}$ and $\epsilon_2 \sim 10^{-1}$ are sufficient to resolve the fast TKE collapse on the slow shear timescale using Fenichel’s theorem.  
**D. Numerical consistency** (required)  
* Verify that the desingularization constant $\delta$ is small enough to not *artifacts* the fold (i.e., the bifurcation point location should be insensitive to $\delta$ for $\delta \lesssim 10^{-5}$).  
  
## The Core Question  
**Does your implementation preserve the three-term competition:** $$\underbrace{c_m \ell S^2 \tilde{e}}*{\text{shear source}} = \underbrace{\frac{g}{\theta_0} q*\theta \cdot N^2}*{\text{buoyant damping}} + \underbrace{\text{dissipation}}*{\text{decay}}$$  
**Or has the “slaved” closure framework disconnected $q_\theta$ from $\tilde{e}$, breaking the feedback loop?**  
**Or has the “slaved” closure framework disconnected $q_\theta$ from $\tilde{e}$, breaking the feedback loop?**  
```
This is not a pedantic question—it determines whether your fold represents the true SBL collapse physics or a partial approximation.


```
