```
### Derivation of the Effective Surface Heat Capacity $\frac{C_s}{1 - \Pi_G}$

To analyze thermal stability across diverse surface regimes (e.g., vegetated soil vs. Arctic ice) without introducing site-specific soil constants, we express conductive ground heat transfer relative to net radiative cooling via the nondimensional ground-flux ratio:

$$\Pi_G = \frac{-G}{R_{\text{net}}(T_s)} = \frac{\frac{k_g}{d_g}(T_s - T_g)}{R_{\text{net}}(T_s)}$$

Substituting $G = -\Pi_G R_{\text{net}}$ into the surface energy balance yields:

$$C_s \frac{dT_s}{dt} = R_{\text{net}}(T_s) - \Pi_G R_{\text{net}}(T_s) + H = (1 - \Pi_G) R_{\text{net}}(T_s) + H$$

Dividing both sides by the factor $(1 - \Pi_G)$ isolates the driving radiative and turbulent forcing terms:

$$\left( \frac{C_s}{1 - \Pi_G} \right) \frac{dT_s}{dt} = R_{\text{net}}(T_s) + \frac{H}{1 - \Pi_G}$$

This formulation reveals that ground coupling re-scales the effective skin heat capacity into:

$$C_s^{\text{eff}} = \frac{C_s}{1 - \Pi_G}$$

---

### Physical Interpretations across Surface Regimes

* **Buffered Regime ($\Pi_G \in (0, 1)$, e.g., CASES-99 Grassland):**
Subsoil heat conduction flows upward into the cooling skin ($G > 0$), counteracting radiative loss ($R_{\text{net}} < 0$). This makes $\Pi_G > 0$, amplifying the effective thermal inertia ($C_s^{\text{eff}} > C_s$). Ground heat acts as a governor, slowing thermal inversion growth and delaying trajectories from approaching the non-hyperbolic fold locus $\mathcal{C}_{\text{fold}}$.
* **Unbuffered / Runaway Regime ($\Pi_G \to 1$ or $\Pi_G < 0$, e.g., SHEBA Sea Ice / Dry Sand):**
Subsurface conductive supply is minimal or insulated ($k_g \to 0$). As $\Pi_G \to 0$, $C_s^{\text{eff}} \to C_s$, removing the thermal inertia buffer. Rapid surface skin cooling accelerates surface inversion growth, driving fast state trajectories across $\mathcal{C}_{\text{fold}}$ and triggering runaway turbulent collapse.

```
