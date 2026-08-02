# 5DGSPTSBL.jl

*A desingularized 5D Geometric Singular Perturbation Theory (GSPT) framework in Julia for modeling stable boundary layer (SBL) turbulence collapse and WSINDy parameter discovery.*

---

## Overview

`5DGSPTSBL.jl` models nocturnal stable boundary layer turbulence collapse using Fenichel's theory for fast-slow dynamical systems. The physical system suffers from an $e = 0$ turbulent kinetic energy (TKE) singularity, which this package resolves via coordinate desingularization $\tilde{e} = \sqrt{e + \delta}$ and fast time rescaling $d\tau = \tilde{e} \, dt$.

The model represents a fully coupled 5D fast-slow system:

* **Fast Subsystem ($\mathbf{x}_f = (\tilde{e}, q_\theta)^T$):** Desingularized TKE ($\tilde{e}$) and kinematic vertical heat flux ($q_\theta$).
* **Slow Subsystem ($\mathbf{x}_s = (S, T_s)^T$):** Vertical wind shear ($S$) and surface skin temperature ($T_s$).
* **Super-Slow Subsystem ($x_{ss} = T_g$):** Deep soil temperature ($T_g$).

The dynamic stratification closure introduces dynamic boundary layer depth $h_{\text{sbl}}(\tilde{e}) = h_{\min} + L_e \tilde{e}$, capturing the physical feedback loop where weakening turbulence sharpens ground inversion without breaking $C^r$-smoothness or Fenichel normal hyperbolicity.

> **Note on Naming Convention:** While the repository and package are named `5DGSPTSBL`, Julia module identifiers cannot start with a digit. Therefore, the module is imported in code as `FiveDGSPTSBL`.

---

## Governing Equations

### 1. Fast Subsystem Dynamics

On fast time scale $\tau$, with slow background variables held constant:

$$\begin{aligned} \frac{d\tilde{e}}{d\tau} &= \frac{1}{2} c_m \ell(z_{\text{eff}}) S^2 \tilde{e} - \frac{g}{2\theta_0} q_\theta - \frac{1}{2\ell(z_{\text{eff}})} \tilde{e}^3 \\ \frac{dq_\theta}{d\tau} &= - c_w \theta_z(T_s, \tilde{e}) \tilde{e}^3 - \frac{g}{\theta_0} c_\theta \ell(z_{\text{eff}}) q_\theta^2 - \frac{C_\theta}{\ell(z_{\text{eff}})} \tilde{e}^2 q_\theta \end{aligned}$$

### 2. Dynamic Stratification & Thermodynamics

$$\theta_z(T_s, \tilde{e}) = \max\left(0, \, \frac{T_0 - T_s}{h_{\min} + L_e \tilde{e}}\right)$$

### 3. Slow & Super-Slow Evolution

$$\frac{dS}{d\tau} = \frac{\epsilon_1}{\max(\tilde{e}, \sqrt{\delta})} \left[ F_{\text{ls}} - \frac{\rho C_d U_1^2}{\rho_0 \Delta z^2} \right]$$

$$\frac{dT_s}{d\tau} = \frac{\epsilon_1}{\max(\tilde{e}, \sqrt{\delta})} \frac{1}{C_s} \left[ R_{\text{net}}(T_s) + \rho c_p q_\theta + \frac{k_g}{d_g}(T_g - T_s) \right]$$

$$\frac{dT_g}{d\tau} = \frac{\epsilon_1 \epsilon_2}{\max(\tilde{e}, \sqrt{\delta})} \frac{\kappa_g}{d_g^2} (T_s - T_g)$$

### 4. Critical Manifold & Fold Locus

The critical manifold $\mathcal{M}_0$ consists of fast equilibrium states where $\dot{\tilde{e}} = 0$ and $\dot{q}_\theta = 0$. The fold catastrophe boundary $\mathcal{C}_{\text{fold}}$ marks the loss of normal hyperbolicity:

$$\det(J_{\text{fast}}) = \det \begin{pmatrix}  \frac{\partial \dot{\tilde{e}}}{\partial \tilde{e}} & \frac{\partial \dot{\tilde{e}}}{\partial q_\theta} \\ \frac{\partial \dot{q}_\theta}{\partial \tilde{e}} & \frac{\partial \dot{q}_\theta}{\partial q_\theta}  \end{pmatrix} = 0$$

---

## Repository Structure

```text
5DGSPTSBL/
├── Project.toml               # Package dependencies and version bounds
├── src/
│   ├── 5DGSPTSBL.jl           # Main module entrypoint (exports FiveDGSPTSBL)
│   ├── types.jl               # SBLParams struct parameterized for Autodiff
│   ├── physics/
│   │   ├── closures.jl        # Physical closures (z_eff, l, h_sbl, theta_z)
│   │   └── rhs.jl             # 5D desingularized system & 2D fast subsystem
│   ├── analysis/
│   │   └── jacobian.jl        # ForwardDiff fast Jacobian, det(J), fold tracking
│   └── wsindy/
│       └── identification.jl  # DataDrivenDiffEq WSINDy parameter identification
├── test/
│   ├── runtests.jl            # Master test suite runner
│   ├── test_closures.jl       # K_m positivity and Autodiff checks
│   ├── test_jacobian.jl       # Fast Jacobian sign-change and delta sensitivity
│   └── test_ode.jl            # Stiff 5D ODE solver verification
└── scripts/
    ├── run_cases99.jl         # CASES-99 12-hour simulation driver
    └── plot_manifold.jl       # CairoMakie manifold visualizer

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

# Initialize physical parameters and initial state
p = SBLParams()
u0 = [0.5, -0.01, 0.05, 285.0, 288.0] # [e_tilde, q_theta, S, Ts, Tg]
tspan = (0.0, 43200.0)                # 12-hour nocturnal cycle

# Solve using stiff solver Rodas5P
prob = ODEProblem(gspt_5d_rhs!, u0, tspan, p)
sol = solve(prob, Rodas5P(), reltol=1e-8, abstol=1e-8)

```

### 2. Evaluating Fast Jacobian and Fold Locus

```julia
using FiveDGSPTSBL

p = SBLParams()
u_fast = [0.2, -0.005]  # [e_tilde, q_theta]
u_slow = [0.03, 280.0]  # [S, Ts]

# Compute 2x2 fast Jacobian matrix via ForwardDiff
J = fast_jacobian(u_fast, u_slow, p)

# Evaluate determinant (sign determines stability)
det_J = jacobian_determinant(u_fast, u_slow, p)

```

### 3. Parameter Discovery with WSINDy

```julia
using FiveDGSPTSBL

# Extract trajectories from simulation or observational data
tau, e_tilde, q_theta, S, Ts = extract_trajectories(sol)

# Recover dimensionless closure parameters (c_m, c_w, c_theta, C_theta)
recovered_params = identify_gspt_closures(tau, e_tilde, q_theta, S, Ts, p; lambda=1e-2)

```

---

## Running Tests

Execute the test suite without precompilation overhead:

```bash
JULIA_PKG_PRECOMPILE_AUTO=0 julia --project=. --compiled-modules=no test/runtests.jl

```

---

## License

This project is licensed under the MIT License. See `LICENSE` for details.