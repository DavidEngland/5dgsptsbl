Adding a systems-level architecture diagram as **Figure 0/1** is a fantastic move. In fast-slow dynamical systems papers, readers often get lost in the state dimensions unless they can immediately map the mathematical states (\tilde{e}, q_\theta, S, T_s, T_g) to physical domains and timescale hierarchies.  
Here is a complete, publication-ready **TikZ** implementation of the model architecture.  
Here is a complete, publication-ready **TikZ** implementation of the model architecture.  
**Required Preamble Packages**  
Add the following TikZ libraries to your main template (templates/paper.tex.mustache):  
```
\usepackage{tikz}
\usetikzlibrary{arrows.meta, positioning, calc, fit, backgrounds, shadow, shapes.geometric}

```
**TikZ Figure Code**  
You can insert this block directly at the beginning of templates/sections/introduction.tex.mustache or templates/sections/governing_equations.tex.mustache:  
You can insert this block directly at the beginning of templates/sections/introduction.tex.mustache or templates/sections/governing_equations.tex.mustache:  
```
\begin{figure}[htbp]
\centering
\begin{tikzpicture}[
    scale=0.95, every node/.style={transform shape},
    % Layer Box Styles
    atmos/.style={rectangle, draw=blue!70!black, fill=blue!5, thick, rounded corners=6pt, minimum width=9.5cm, minimum height=2.2cm, align=center},
    skin/.style={rectangle, draw=orange!80!black, fill=orange!8, thick, rounded corners=6pt, minimum width=9.5cm, minimum height=1.6cm, align=center},
    soil/.style={rectangle, draw=brown!70!black, fill=brown!10, thick, rounded corners=6pt, minimum width=9.5cm, minimum height=1.4cm, align=center},
    % Annotation Card Styles
    card/.style={rectangle, draw=gray!60, fill=gray!5, dense, rounded corners=4pt, inner sep=6pt, font=\footnotesize, align=left},
    % Arrow Styles
    flux/.style={-Stealth, ultra thick, line cap=round},
    annotation/.style={-Kite, thick, dashed, color=gray!80!black}
]

    % =========================================================================
    % MAIN PHYSICAL DOMAIN BLOCKS
    % =========================================================================
    
    % Atmospheric Boundary Layer
    \node[atmos] (ATM) at (0, 3.8) {};
    \node[anchor=north west, font=\bfseries\small, text=blue!80!black] at (ATM.north west) {\hspace{0.2cm} Atmospheric Boundary Layer (Interior Mixing)};
    \node[font=\small] at (ATM.center) {
        \begin{tabular}{c c}
            \textbf{Fast Subsystem State} ($\tau = t / \tilde{e}$): & \textbf{Slow Forcing State} ($t$): \\
            Desingularized TKE: $\tilde{e} = \sqrt{e + \delta}$ & Vertical Shear: $S = \partial U / \partial z$ \\
            Turbulent Heat Flux: $q_\theta = \overline{w'\theta'}$ & Prescribed Driving: $\mathcal{F}_S = \gamma_S (S_{\text{geo}} - S)$
        \end{tabular}
    };

    % Surface Skin Layer
    \node[skin, below=0.9cm of ATM] (SKIN) {};
    \node[anchor=north west, font=\bfseries\small, text=orange!90!black] at (SKIN.north west) {\hspace{0.2cm} Surface Skin Layer (Thermal Interface)};
    \node[font=\small] at (SKIN.center) {
        \textbf{Slow Thermal State} ($t$): Skin Temperature $T_s$ \\[2pt]
        Effective Thermal Capacity: $C_s^{\text{eff}} = \frac{C_s}{1 - \Pi_G} \quad \Longrightarrow \quad \varepsilon(\Pi_G) = \varepsilon_0(1 - \Pi_G)$
    };

    % Deep Soil Layer
    \node[soil, below=0.9cm of SKIN] (SOIL) {};
    \node[anchor=north west, font=\bfseries\small, text=brown!80!black] at (SOIL.north west) {\hspace{0.2cm} Subsurface Soil Layer (Thermal Reservoir)};
    \node[font=\small] at (SOIL.center) {
        \textbf{Super-Slow State} ($\epsilon_2 t$): Deep Soil Temperature $T_g$ \\[2pt]
        Conductive Diffusion: $\frac{d T_g}{d t} = \frac{\kappa_g}{d_g^2}(T_s - T_g)$
    };

    % =========================================================================
    % INTERFACIAL FLUX ARROWS
    % =========================================================================
    
    % Sensible Heat Flux (Atmosphere <-> Skin)
    \draw[flux, color=red!70!black] ($(ATM.south)+(-2.2,0)$) -- node[right, font=\footnotesize\bfseries] {Sensible Flux $H = \rho c_p q_\theta$} ($(SKIN.north)+(-2.2,0)$);
    
    % Net Radiative Cooling (Skin Outward)
    \draw[flux, color=purple!70!black] ($(SKIN.north)+(2.2,0)$) -- node[right, font=\footnotesize\bfseries] {Radiative Loss $R_{\text{net}}(T_s) < 0$} ($(ATM.south)+(2.2,0)$);

    % Ground Heat Flux (Soil <-> Skin)
    \draw[flux, color=brown!80!black] ($(SOIL.north)+(0,0)$) -- node[right, font=\footnotesize\bfseries] {Soil Flux $G = \frac{k_g}{d_g}(T_g - T_s) = -\Pi_G R_{\text{net}}$} ($(SKIN.south)+(0,0)$);

    % =========================================================================
    % SIDE ANNOTATION CARDS (GSPT GEOMETRY & OBSERVABLES)
    % =========================================================================

    % Left Card: Timescale & Singular Perturbation Hierarchy
    \node[card, left=0.8cm of SKIN, anchor=east, width=4.2cm] (LEFT_CARD) {
        \textbf{\color{blue!80!black} GSPT Hierarchy} \\[3pt]
        $\bullet$ \textbf{Fast ($\tau$):} $\tilde{e}, q_\theta$ \\
        \hspace{0.3cm}\textit{(Turbulent relaxation)} \\[2pt]
        $\bullet$ \textbf{Slow ($t$):} $S, T_s$ \\
        \hspace{0.3cm}\textit{(Shear drive, SEB)} \\[2pt]
        $\bullet$ \textbf{Super-Slow ($\epsilon_2 t$):} $T_g$ \\
        \hspace{0.3cm}\textit{(Subsurface conduction)}
    };

    % Right Card: Fold Locus & Rank-1 Observation Map
    \node[card, right=0.8cm of SKIN, anchor=west, width=4.5cm] (RIGHT_CARD) {
        \textbf{\color{red!80!black} Geometry \& Observable} \\[3pt]
        $\bullet$ \textbf{Fold Locus $\mathcal{C}_{\text{fold}}$:} \\
        \hspace{0.3cm}$\det(J_{\text{fast}}) = 0$ \\
        \hspace{0.3cm}\textit{(Loss of normal hyperbolicity)} \\[3pt]
        $\bullet$ \textbf{Rank-1 Observation Map:} \\
        \hspace{0.3cm}$\pi_{Ri}(\mathbf{x}) = \frac{g \theta_z(T_s, \tilde{e})}{\theta_0 S^2}$ \\[3pt]
        $\star$ \textbf{Scatter Mechanism:} \\
        \hspace{0.3cm}$Ri_{\text{crit}}$ is a fiber projection \\
        \hspace{0.3cm}modulated by $\Pi_G$.
    };

    % Connector lines from cards to central architecture
    \draw[annotation] (LEFT_CARD.east) -- (SKIN.west);
    \draw[annotation] (RIGHT_CARD.west) -- (SKIN.east);

\end{tikzpicture}
\caption{\textbf{Architecture of the 5D GSPT-SBL Model.} Schematic representation of the coupled atmospheric-surface-subsurface system showing the state vector $\mathbf{x} = (\tilde{e}, q_\theta, S, T_s, T_g)^T$, interfacial energy fluxes ($H, R_{\text{net}}, G$), and GSPT timescale separation. Subsurface thermal coupling modulates the singular perturbation parameter $\varepsilon(\Pi_G)$, while collapse events occur along the fold locus $\mathcal{C}_{\text{fold}}$, whose rank-1 scalar projection yields campaign-dependent $Ri_{\text{crit}}$ values.}
\label{fig:model_architecture}
\end{figure}

```
**Highlights of this Diagram**  
1. **Clear Physical Layering:** Uses distinct, soft color coding for Atmosphere (Blue), Surface Skin (Orange), and Deep Soil (Brown).  
2. **Clear Physical Layering:** Uses distinct, soft color coding for Atmosphere (Blue), Surface Skin (Orange), and Deep Soil (Brown).  
3. **Coupled Fluxes Included:** Explicitly highlights H = \rho c_p q_\theta, R_{\text{net}}(T_s), and G = \frac{k_g}{d_g}(T_g - T_s) along with the exact identity G = -\Pi_G R_{\text{net}}.  
4. **Coupled Fluxes Included:** Explicitly highlights H = \rho c_p q_\theta, R_{\text{net}}(T_s), and G = \frac{k_g}{d_g}(T_g - T_s) along with the exact identity G = -\Pi_G R_{\text{net}}.  
5. **Left Annotation Panel (Timescale Hierarchy):** Clearly breaks down fast (\tau), slow (t), and super-slow (\epsilon_2 t) dynamic variables.  
6. **Left Annotation Panel (Timescale Hierarchy):** Clearly breaks down fast (\tau), slow (t), and super-slow (\epsilon_2 t) dynamic variables.  
7. **Right Annotation Panel (Geometric Mechanics):** Directly connects the state space to the non-hyperbolic fold locus \mathcal{C}_{\text{fold}} and the rank-1 projection map \pi_{Ri}, giving immediate visual context to the paper's core theoretical argument.  
8. **Right Annotation Panel (Geometric Mechanics):** Directly connects the state space to the non-hyperbolic fold locus \mathcal{C}_{\text{fold}} and the rank-1 projection map \pi_{Ri}, giving immediate visual context to the paper's core theoretical argument.  
