# 5DGSPTSBL.jl

*A desingularized 5D Geometric Singular Perturbation Theory (GSPT) framework in Julia for modeling stable boundary layer (SBL) turbulence collapse and WSINDy parameter discovery.*

---

## Overview

`5DGSPTSBL.jl` models nocturnal stable boundary layer turbulence collapse using Fenichel theory for fast-slow dynamical systems. Physical SBL modeling frequently suffers from a singularity at $e = 0$ in the turbulent kinetic energy (TKE) flux equations. This package resolves the singularity via a $C^\infty$-smooth coordinate chart desingularization $\tilde{e} = \sqrt{e + \delta}$ and a fast time rescaling $d\tau = \tilde{e} \, dt$.

The physical model represents a fully coupled 5D fast-slow dynamical system across three distinct time scales:

* **Fast Subsystem ($\mathbf{x}_f = (\tilde{e}, q_\theta)^T$):** Desingularized TKE ($\tilde{e}$) and kinematic vertical heat flux ($q_\theta$).
* **Slow Subsystem ($\mathbf{x}_s = (S, T_s)^T$):** Vertical wind shear ($S$) and surface skin temperature ($T_s$).
* **Super-Slow Subsystem ($x_{ss} = T_g$):** Deep soil temperature ($T_g$).

The dynamic stratification closure incorporates an adaptive boundary layer height $h_{\text{sbl}}(\tilde{e}) = h_{\min} + L_e \tilde{e}$. This captures the physical feedback where weakening turbulence sharpens the ground inversion without breaking $C^r$-smoothness or Fenichel normal hyperbolicity.

> **Important — Julia Module Naming Convention**
> Because Julia syntax prohibits module identifiers from starting with a numerical digit, the package module is named and imported in Julia code as **`FiveDGSPTSBL`**, whereas the GitHub repository and package entry maintain the official project name **`5DGSPTSBL`**.

---

## Governing Equations

### 1. Fast Subsystem Dynamics

On the fast time scale $\tau$, holding slow background variables constant:

$$\begin{aligned} \frac{d\tilde{e}}{d\tau} &= \frac{1}{2} c_m \ell(z_{\text{eff}}) S^2 \tilde{e} - \frac{g}{2\theta_0} q_\theta - \frac{1}{2\ell(z_{\text{eff}})} \tilde{e}^3 \\ \frac{dq_\theta}{d\tau} &= - c_w \theta_z(T_s, \tilde{e}) \tilde{e}^3 - \frac{g}{\theta_0} c_\theta \ell(z_{\text{eff}}) q_\theta^2 - \frac{C_\theta}{\ell(z_{\text{eff}})} \tilde{e}^2 q_\theta \end{aligned}$$

### 2. Dynamic Stratification Closure

$$\theta_z(T_s, \tilde{e}) = \max\left(0, \, \frac{T_0 - T_s}{h_{\min} + L_e \tilde{e}}\right)$$

### 3. Slow & Super-Slow Evolution

$$\begin{aligned} \frac{dS}{d\tau} &= \frac{\epsilon_1}{\max(\tilde{e}, \sqrt{\delta})} \left[ F_{\text{ls}} - \frac{\rho C_d U_1^2}{\rho_0 \Delta z^2} \right] \\ \frac{dT_s}{d\tau} &= \frac{\epsilon_1}{\max(\tilde{e}, \sqrt{\delta})} \frac{1}{C_s} \left[ R_{\text{net}}(T_s) + \rho c_p q_\theta + \frac{k_g}{d_g}(T_g - T_s) \right] \\ \frac{dT_g}{d\tau} &= \frac{\epsilon_1 \epsilon_2}{\max(\tilde{e}, \sqrt{\delta})} \frac{\kappa_g}{d_g^2} (T_s - T_g) \end{aligned}$$

### 4. Critical Manifold & Fold Locus

The critical manifold $\mathcal{M}_0$ consists of equilibrium states of the fast subsystem where $\dot{\tilde{e}} = 0$ and $\dot{q}_\theta = 0$. The fold catastrophe boundary $\mathcal{C}_{\text{fold}}$ marks the failure of normal hyperbolicity:

$$\det(J_{\text{fast}}) = \det \begin{pmatrix} \frac{\partial \dot{\tilde{e}}}{\partial \tilde{e}} & \frac{\partial \dot{\tilde{e}}}{\partial q_\theta} \\ \frac{\partial \dot{q}_\theta}{\partial \tilde{e}} & \frac{\partial \dot{q}_\theta}{\partial q_\theta} \end{pmatrix} = 0$$

---

## Repository Structure

```text
5DGSPTSBL/
├── Project.toml               # Package dependencies and version bounds
├── src/
│   ├── 5DGSPTSBL.jl           # Module entrypoint (defines FiveDGSPTSBL)
│   ├── types.jl               # SBLParams struct parameterized for Autodiff
│   ├── physics/
│   │   ├── closures.jl        # Physical closures (z_eff, l, h_sbl, theta_z)
│   │   ├── rhs.jl             # 5D desingularized system & 2D fast subsystem
│   │   └── scm.jl             # Multi-layer Single-Column Model (SCM) PDE extension
│   ├── analysis/
│   │   ├── jacobian.jl        # Fast Jacobian, det(J), fold locus tracking
│   │   └── bifurcations.jl   # Cusp / BT point tracking & hysteresis metrics
│   └── wsindy/
│       └── identification.jl  # DataDrivenDiffEq WSINDy parameter identification
├── test/
│   ├── runtests.jl            # Master test suite runner
│   ├── test_closures.jl       # Positivity, stratification, and Autodiff checks
│   ├── test_jacobian.jl       # Fast Jacobian sign-change checks
│   ├── test_bifurcations.jl   # Codim-2 point detection tests
│   ├── test_delta_sensitivity.jl # Delta regularization invariance checks
│   ├── test_scm.jl            # SCM grid and tendency checks
│   └── test_ode.jl            # Stiff 5D ODE solver verification
└── scripts/
    ├── run_cases99.jl         # CASES-99 simulation driver
    └── plot_manifold.jl       # CairoMakie phase-space visualizer

```

---

## Installation & Setup

Clone the repository and instantiate the environment:

```bash
git clone https://github.com/your-org/5DGSPTSBL.git
cd 5DGSPTSBL
julia --project=. -e 'using Pkg; Pkg.instantiate()'

```

---

## Quickstart Examples

### 1. Integrating the 5D Fast-Slow System

```julia
using DifferentialEquations
using FiveDGSPTSBL

# Initialize physical parameters and state vector
p = SBLParams()
u0 = [0.5, -0.01, 0.05, 285.0, 288.0]  # [e_tilde, q_theta, S, Ts, Tg]
tspan = (0.0, 43200.0)                 # 12-hour nocturnal integration

# Solve using stiff adaptive solver Rodas5P
prob = ODEProblem(gspt_5d_rhs!, u0, tspan, p)
sol = solve(prob, Rodas5P(); reltol=1e-8, abstol=1e-8, dtmin=1e-12)

```

### 2. Evaluating Fast Jacobian and Fold Locus

```julia
using StaticArrays
using FiveDGSPTSBL

p = SBLParams()
u_fast = SVector(0.2, -0.005)  # [e_tilde, q_theta]
u_slow = SVector(0.03, 280.0)  # [S, Ts]

# Compute 2x2 fast Jacobian matrix via ForwardDiff
J = fast_jacobian(u_fast, u_slow, p)

# Evaluate determinant (sign determines normal hyperbolicity)
det_J = jacobian_determinant(u_fast, u_slow, p)

```

### 3. Parameter Discovery with WSINDy

```julia
using FiveDGSPTSBL

# Extract state trajectories from observational tower data or DNS
tau, e_tilde, q_theta, S, Ts = extract_trajectories(sol)

# Recover dimensionless closure parameters (c_m, c_w, c_theta, C_theta)
recovered_params = identify_gspt_closures(tau, e_tilde, q_theta, S, Ts, p; lambda=1e-2)

```

---

## Running Tests

Execute the full suite across closures, bifurcations, delta-sensitivity, and SCM integration:

```bash
julia --project=. test/runtests.jl

```

---

## License

This project is licensed under the MIT License. See `LICENSE` for details.

---

### Key Improvements Made:

1. **Module Name Callout:** Placed an explicit, styled callout box near the top explaining the `5DGSPTSBL` vs `FiveDGSPTSBL` identifier requirement so users understand imports right away.
2. **Mathematical Notation:** Cleaned up multi-line system alignments using `\begin{aligned}` and ensured consistent subscripting and variable names matching your latest codebase implementations.
3. **Updated Repository Tree & Quickstart:** Incorporated newly added files (`scm.jl`, `bifurcations.jl`, `test_delta_sensitivity.jl`, `test_scm.jl`) and added `dtmin=1e-12` to the `solve` call in the quickstart example to prevent step-size warning artifacts.