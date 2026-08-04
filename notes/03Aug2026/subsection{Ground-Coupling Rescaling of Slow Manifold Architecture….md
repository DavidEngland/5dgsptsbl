\subsection{Ground-Coupling Rescaling of Slow Manifold Architecture}  
\label{subsec:ground_coupling_rescaling}  
  
To incorporate conductive soil thermal coupling without introducing site-specific soil properties (such as moisture-dependent thermal conductivity $k_g$ or effective skin depth $d_g$), ground heat transfer is expressed relative to net radiative forcing via the nondimensional ground-flux ratio $\Pi_G$.  
  
\subsubsection{Ground-Flux Ratio and Sign Convention}  
Under nocturnal conditions, net longwave radiation acts as a surface heat sink ($R_{\text{net}} < 0$). We define upward ground heat flux into the skin layer as positive ($G > 0$, warming the skin). The ground-flux ratio is defined as:  
\begin{equation}  
\Pi_G = \frac{-G}{R_{\text{net}}(T_s)} = \frac{\frac{k_g}{d_g}(T_s - T_g)}{R_{\text{net}}(T_s)}.  
\label{eq:Pi_G_def}  
\end{equation}  
Because both $-G < 0$ and $R_{\text{net}} < 0$ during typical nocturnal cooling with upward soil heat supply ($T_g > T_s$), the parameter satisfies $\Pi_G > 0$. Rearranging \eqref{eq:Pi_G_def} yields the exact flux substitution:  
\begin{equation}  
G = -\Pi_G R_{\text{net}}(T_s).  
\label{eq:exact_G_substitution}  
\end{equation}  
Normalizing ground heat transfer by $R_{\text{net}}$ eliminates direct parameterization of subsoil thermal conductivity and layer depth, yielding a dimensionless coupling parameter $\Pi_G$ that isolates the dynamic effect of subsurface heat supply on surface energy dynamics.  
  
\subsubsection{Derivation of Effective Surface Heat Capacity}  
Skin temperature evolution is governed by the lumped surface energy balance (SEB):  
\begin{equation}  
C_s \frac{dT_s}{dt} = R_{\text{net}}(T_s) + H + G,  
\label{eq:seb_base}  
\end{equation}  
where $C_s$ is the physical heat capacity of the skin layer and $H = \rho c_p q_\theta$ is the sensible turbulent heat flux. Substituting the exact identity $G = -\Pi_G R_{\text{net}}(T_s)$ into \eqref{eq:seb_base} yields:  
\begin{equation}  
C_s \frac{dT_s}{dt} = (1 - \Pi_G) R_{\text{net}}(T_s) + H.  
\label{eq:seb_substituted}  
\end{equation}  
Dividing both sides by the coupling factor $(1 - \Pi_G)$ isolates the driving radiative and turbulent forcing terms:  
\begin{equation}  
\left( \frac{C_s}{1 - \Pi_G} \right) \frac{dT_s}{dt} = R_{\text{net}}(T_s) + \frac{H}{1 - \Pi_G}.  
\label{eq:seb_isolated}  
\end{equation}  
Equation \eqref{eq:seb_isolated} defines the effective surface heat capacity:  
\begin{equation}  
C_s^{\text{eff}} = \frac{C_s}{1 - \Pi_G}.  
\label{eq:C_s_eff}  
\end{equation}  
\begin{quote}  
\textbf{Note:} Equation \eqref{eq:C_s_eff} is an exact algebraic identity derived directly from the surface energy balance, rather than a heuristic or empirical approximation.  
\end{quote}  
  
\subsubsection{Rescaling of the Slow Thermal Timescale}  
The local surface thermal response time $\tau_s$ is determined by the ratio of effective heat capacity to the linearized radiative feedback:  
\begin{equation}  
\tau_s(\Pi_G) = \frac{C_s^{\text{eff}}}{\lambda_R},  
\label{eq:tau_s_def}  
\end{equation}  
where $\lambda_R = \left| \frac{\partial R_{\text{net}}}{\partial T_s} \right| = -\frac{\partial R_{\text{net}}}{\partial T_s} > 0$ represents the linearized radiative cooling feedback factor. Substituting \eqref{eq:C_s_eff} into \eqref{eq:tau_s_def} yields:  
\begin{equation}  
\tau_s(\Pi_G) = \frac{C_s}{\lambda_R (1 - \Pi_G)} = \frac{\tau_{s,0}}{1 - \Pi_G},  
\label{eq:tau_s_rescaled}  
\end{equation}  
where $\tau_{s,0} = \frac{C_s}{\lambda_R}$ represents the uncoupled surface thermal response time ($\Pi_G = 0$). Ground heat transfer directly rescales the surface thermal timescale by $(1 - \Pi_G)^{-1}$.  
  
\subsubsection{Modification of the Singular Perturbation Parameter}  
In the Geometric Singular Perturbation Theory (GSPT) formulation of the stable boundary layer, the fundamental nondimensional parameter governing timescale separation between fast turbulent relaxation ($\tau_{\text{turb}}$) and slow surface thermal evolution ($\tau_s$) is:  
\begin{equation}  
\varepsilon(\Pi_G) = \frac{\tau_{\text{turb}}}{\tau_s(\Pi_G)}.  
\label{eq:epsilon_def}  
\end{equation}  
Substituting the rescaled thermal timescale \eqref{eq:tau_s_rescaled} into \eqref{eq:epsilon_def} gives:  
\begin{equation}  
\varepsilon(\Pi_G) = \frac{\tau_{\text{turb}}}{\tau_{s,0} / (1 - \Pi_G)} = \left( \frac{\tau_{\text{turb}}}{\tau_{s,0}} \right) (1 - \Pi_G).  
\label{eq:epsilon_derivation}  
\end{equation}  
Defining $\varepsilon_0 = \frac{\tau_{\text{turb}}}{\tau_{s,0}}$ as the baseline singular perturbation parameter in the absence of soil coupling, we obtain the scaling relation:  
\begin{equation}  
\varepsilon(\Pi_G) = \varepsilon_0 (1 - \Pi_G).  
\label{eq:epsilon_scaling}  
\end{equation}  
Equation \eqref{eq:epsilon_scaling} proves that subsurface conductive coupling directly modulates the fast-slow timescale separation parameter $\varepsilon$, rather than acting merely as a surface boundary forcing term.  
  
\subsubsection{Geometric Interpretation and Dynamic Regimes}  
Under Fenichel's Theorem, normal hyperbolicity and the existence of an attracting slow manifold $\mathcal{M}_\varepsilon$ require strong timescale separation ($\varepsilon \ll 1$). The rescaled perturbation parameter $\varepsilon(\Pi_G)$ governs trajectory speed and structural stability along this manifold:  
\begin{itemize}  
    \item \textbf{Strong Timescale Separation ($\Pi_G \to 1^-$):} As $\Pi_G \to 1^-$, $\varepsilon(\Pi_G) \to 0$. This reinforces Fenichel normal hyperbolicity, pinning state trajectories tightly to the attracting branch $\mathcal{M}_\varepsilon^+$. Subsurface conductive supply balances radiative losses, slowing trajectory evolution and delaying or preventing approach to the fold locus $\mathcal{C}_{\text{fold}}$.  
    \item \textbf{Reduced Timescale Separation ($\Pi_G \le 0$):} On unbuffered or insulating surfaces, $\varepsilon(\Pi_G) \ge \varepsilon_0$. The absence of ground buffering accelerates trajectory drift along the slow manifold, driving the system rapidly toward $\mathcal{C}_{\text{fold}}$ where normal hyperbolicity breaks down and turbulence collapse ensues.  
\end{itemize}  
  
The dynamic effects of ground coupling across physical regimes are summarized in Table~\ref{tab:ground_coupling_regimes}.  
  
\begin{table}[htbp]  
\centering  
\caption{Dynamical classification of ground-coupling regimes and their GSPT manifold consequences.}  
\label{tab:ground_coupling_regimes}  
\begin{tabular}{l c c p{6.5cm}}  
\hline\hline  
\textbf{Regime} & \textbf{Ground Ratio $\Pi_G$} & \textbf{Effective Capacity $C_s^{\text{eff}}$} & \textbf{GSPT Dynamic Consequence} \\  
\hline  
Weak Buffering & $\Pi_G \le 0$ & $C_s^{\text{eff}} \le C_s$ & Accelerated drift along $\mathcal{M}_\varepsilon$; rapid approach to fold locus $\mathcal{C}_{\text{fold}}$ and heightened collapse vulnerability (e.g., Arctic sea ice, dry sand). \\  
Moderate Buffering & $0 < \Pi_G < 1$ & $C_s^{\text{eff}} > C_s$ & Lengthened thermal timescale $\tau_s$; stabilized evolution along attracting manifold $\mathcal{M}_\varepsilon$, delaying collapse transition (e.g., grassland, moist soil). \\  
Strong Buffering & $\Pi_G \to 1^-$ & $C_s^{\text{eff}} \to \infty$ & Asymptotic limit $\varepsilon \to 0$; ground heat balances radiative deficit ($G \approx -R_{\text{net}}$), making $\mathcal{C}_{\text{fold}}$ unreachable on finite timescales. \\  
\hline\hline  
\end{tabular}  
\end{table}  
  
\subsubsection{Reconciliation of Critical Richardson Number Scatter}  
The scaling relationship $\varepsilon(\Pi_G) = \varepsilon_0 (1 - \Pi_G)$ provides a geometric resolution to the long-standing observational scatter in critical Richardson numbers ($Ri_c$) across field campaign datasets. Empirical variations in $Ri_c$ (e.g., CASES-99 vs.\ SHEBA) do not indicate a failure of universal turbulence closure physics. Instead, site-specific soil thermodynamics map directly onto $\Pi_G$, modulating the singular perturbation parameter $\varepsilon$. This determines the rate of trajectory evolution along the attracting slow manifold and the precise location where state trajectories cross the fold boundary $\mathcal{C}_{\text{fold}}$. Consequently, observed variations in $Ri_c$ represent low-dimensional projections of ground-coupling modulation on slow-manifold geometry.  
