\documentclass[tikz,border=5pt]{standalone}
\usepackage{amsmath,amssymb}
\usepackage{tikz}  
\usetikzlibrary{shapes.geometric, arrows.meta, positioning, fit, backgrounds, calc}  
  
\begin{document}  
  
\begin{figure}[htbp]  
  \centering  
  \begin{tikzpicture}[  
    >=Stealth,  
    node distance=1.6cm and 2.0cm,  
    font=\sffamily\small,  
    % Box Styles  
    block/.style={  
      draw,  
      rounded corners=4pt,  
      thick,  
      inner sep=10pt,  
      align=left,  
      minimum width=6.6cm  
    },  
    atmos/.style={  
      block,  
      fill=blue!4,  
      draw=blue!60!black  
    },  
    ground/.style={  
      block,  
      fill=orange!4,  
      draw=orange!70!black  
    },  
    gspt/.style={  
      block,  
      fill=purple!4,  
      draw=purple!60!black,  
      minimum width=6.8cm  
    },  
    arrow/.style={  
      ->,  
      thick,  
      line width=1.1pt  
    }  
  ]  
  
    % =========================================================================  
    % NODES  
    % =========================================================================  
  
    % 1. Atmospheric Dynamics Node  
    \node [atmos] (atmos_box) {  
      \textbf{\color{blue!70!black} Atmospheric Boundary Layer Dynamics}\\[4pt]  
      \textbullet~\textbf{Regularized TKE}: $\tilde{e} = \sqrt{e + \delta}$ \textit{(singularity suppression)}\\[2pt]  
      \textbullet~\textbf{Dimensionless Time}: $\tau = t / t_e$, where $t_e = L / \sqrt{\tilde{e}}$\\[2pt]  
      \textbullet~\textbf{Viscous Damping}: $\varepsilon(\Pi_G) = \varepsilon_0 (1 - \Pi_G)$  
    };  
  
    % 2. Surface Energy & Ground Node  
    \node [ground, below=1.2cm of atmos_box] (ground_box) {  
      \textbf{\color{orange!80!black} Surface Energy Balance \& Ground Coupling}\\[4pt]  
      \textbullet~\textbf{Radiative Loss}: $R_{\text{net}}(T_s) < 0$\\[2pt]  
      \textbullet~\textbf{Ground Heat Flux}: $G = -\Pi_G R_{\text{net}} = \frac{k_g}{d_g}(T_g - T_s)$\\[2pt]  
      \textbullet~\textbf{Effective Capacity (Ground Coupling)}: $C_s^{\text{eff}} = \frac{C_s}{1 - \Pi_G}$\\[2pt]  
      \textbullet~\textbf{Conductive Diffusion}: $\frac{d T_g}{d t} = \frac{\kappa_g}{d_g^2}(T_s - T_g)$  
    };  
  
    % 3. GSPT & Bifurcation Right Card  
    \node [gspt, right=1.8cm of $(atmos_box.north east)!0.5!(ground_box.south east)$] (gspt_box) {  
      \textbf{\color{purple!70!black} GSPT Observation Map \& Fold Bifurcation}\\[4pt]  
      \textbullet~\textbf{Observation Map}:\\  
      \hspace*{1em}$\pi_{Ri}(\tilde{e}, S, T_s; \Pi_G) := \dfrac{g (T_s - T_0) z_{\text{ref}}}{\theta_0 S^2(1 + \Pi_G)}$\\[5pt]  
      \textbullet~\textbf{Fold Bifurcation Dynamics}:\\  
      \hspace*{1em}Collapse locus: $\tilde{e} \to \tilde{e}_{\text{fold}}(S, \Pi_G)$ along $\mathcal{C}_{\text{fold}}$\\[5pt]  
      \textbullet~\textbf{Hysteresis Gap}:\\  
      \hspace*{1em}$\Delta Ri_H \propto \Pi_G$ \textit{(radiative collapse loop closure)}  
    };  
  
    % =========================================================================  
    % ARROWS & COUPLING LOOPS  
    % =========================================================================  
  
    % Coupling between Atmosphere & Ground  
    \draw [arrow, color=blue!60!black] ($(atmos_box.south west)!0.3!(atmos_box.south east)$) --   
          node[right, font=\scriptsize\sffamily, align=left] {Turbulent Flux\\Modulation}   
          ($(ground_box.north west)!0.3!(ground_box.north east)$);  
  
    \draw [arrow, color=orange!70!black] ($(ground_box.north west)!0.7!(ground_box.north east)$) --   
          node[left, font=\scriptsize\sffamily, align=right] {Ground Coupling $\Pi_G$\\Dampens $\varepsilon(\Pi_G)$}   
          ($(atmos_box.south west)!0.7!(atmos_box.south east)$);  
  
    % Physical System -> GSPT Manifold Mapping  
    \draw [arrow, color=purple!60!black] (atmos_box.east) --   
          node[above, font=\scriptsize\sffamily, sloped] {State $(\tilde{e}, \tau)$}   
          (gspt_box.west |- atmos_box.east);  
  
    \draw [arrow, color=purple!60!black] (ground_box.east) --   
          node[below, font=\scriptsize\sffamily, sloped] {Coupling $G(T_s, T_g)$}   
          (gspt_box.west |- ground_box.east);  
  
    % =========================================================================  
    % BACKGROUND FRAMES  
    % =========================================================================  
  
    \begin{scope}[on background layer]  
      \node [draw=black!25, fill=black!2, dashed, rounded corners=8pt, inner sep=12pt,  
             fit=(atmos_box) (ground_box),   
             label={[font=\sffamily\bfseries\color{black!70}]above:Physical Boundary Layer Subsystem}] (physical_layer) {};  
  
      \node [draw=purple!30, fill=purple!2, dashed, rounded corners=8pt, inner sep=12pt,  
             fit=(gspt_box),   
             label={[font=\sffamily\bfseries\color{purple!80!black}]above:Reduced Phase Space \& Observation Model}] (gspt_layer) {};  
    \end{scope}  
  
  \end{tikzpicture}  
  \caption{Geometric Singular Perturbation Theory (GSPT) coupling architecture between atmospheric turbulence ($\tilde{e}$) and ground heat flux ($G$). Dimensionless time is rescaled via $\tau = t / t_e$ where $t_e = L/\sqrt{\tilde{e}}$.}  
  \label{fig:gspt_architecture}  
\end{figure}  
  
\end{document}  
