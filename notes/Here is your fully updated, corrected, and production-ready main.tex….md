Here is your fully updated, corrected, and production-ready main.tex file incorporating all 10 fixes.  
```
\documentclass[11pt,a4paper]{article}

% ==============================================================================
% 1. PACKAGES
% ==============================================================================

% --- Geometry & Layout ---
\usepackage[margin=1in]{geometry}
\usepackage{microtype}

% --- Mathematics ---
\usepackage{amsmath,amssymb,amsfonts,amsthm}

% --- Figures & Tables ---
\usepackage{graphicx}
\usepackage{booktabs}

% --- TikZ & Graphics Libraries ---
\usepackage{tikz}
\usetikzlibrary{
    arrows.meta,
    positioning,
    calc,
    decorations.pathmorphing,
    shapes.geometric
}

% --- Bibliography ---
\usepackage{natbib}

% --- Hyperlinks (Loaded last for package compatibility) ---
\usepackage[
    colorlinks=true,
    linkcolor=blue,
    citecolor=blue,
    urlcolor=blue
]{hyperref}

% ==============================================================================
% 2. THEOREM ENVIRONMENTS (Shared Counter by Section)
% ==============================================================================

\theoremstyle{plain}
\newtheorem{theorem}{Theorem}[section]
\newtheorem{lemma}[theorem]{Lemma}
\newtheorem{corollary}[theorem]{Corollary}
\newtheorem{proposition}[theorem]{Proposition}

\theoremstyle{definition}
\newtheorem{definition}[theorem]{Definition}
\newtheorem{assumption}[theorem]{Assumption}

\theoremstyle{remark}
\newtheorem{remark}[theorem]{Remark}

% ==============================================================================
% 3. CUSTOM MATH OPERATORS & COMMANDS
% ==============================================================================

% Operators
\DeclareMathOperator{\TKE}{e}
\DeclareMathOperator{\rank}{rank}
\DeclareMathOperator{\diag}{diag}
\DeclareMathOperator{\spanop}{span}
\DeclareMathOperator{\trace}{tr}

% Sets & Symbols
\newcommand{\R}{\mathbb{R}}

% Differential Notation
\newcommand{\dd}{\,\mathrm{d}}
\newcommand{\ddt}[1]{\frac{\mathrm{d}#1}{\mathrm{d}t}}
\newcommand{\partialderiv}[2]{\frac{\partial #1}{\partial #2}}

% ==============================================================================
% 4. METADATA
% ==============================================================================

\title{\textbf{Geometric Singular Perturbation Theory of the Stable Boundary Layer:\\ Invariant Fold Geometry, Relaxation Oscillations, and Model Closures}\\
\large Part 1: Mathematical Foundations and Observational Resolution}

\author{
    \textbf{David E. England, PhD}\thanks{Corresponding author: \href{mailto:david.england@uah.edu}{david.england@uah.edu}} \\
    \small Research Engineer III \\
    \small University of Alabama in Huntsville (UAH)
}

\date{\small\itshape Manuscript prepared for SBL-GSPT collaborative research project stack. \\ Last compiled: \today}

% ==============================================================================
% 5. DOCUMENT BODY
% ==============================================================================

\begin{document}

\maketitle

% --- Abstract ---
\begin{abstract}
Traditional turbulence closures in numerical weather prediction (NWP) models rely on single-valued stability functions $f(Ri)$ or $f(\zeta)$ that treat the nocturnal stable boundary layer (SBL) as a continuous, quasi-equilibrium process. Consequently, operational models struggle under clear, calm conditions—either overestimating turbulent mixing or triggering runaway radiative collapse. In this work, we present a mathematically rigorous dynamical systems framework for the SBL using Geometric Singular Perturbation Theory (GSPT).

By formulating a five-dimensional fast-slow atmospheric boundary layer system $(\tilde e, q_\theta, S, T_s, T_g)$, we prove via Fenichel theory that the fast turbulent dynamics collapse onto a three-dimensional, normally hyperbolic critical manifold $\mathcal{S}_0^+$. Environmental boundary conditions define a three-dimensional site constraint manifold $\Sigma_{\mathrm{site}}$, which intersects $\mathcal{S}_0^+$ transversally ($\mathcal{S}_0^+ \pitchfork \Sigma_{\mathrm{site}}$) to form a smooth one-dimensional physical site trajectory $\gamma_{\mathrm{site}}$.

We show that when surface radiative cooling exceeds the maximum turbulent heat transport capacity ($Q_{\mathrm{rad}} > H_{\max}$), normal hyperbolicity breaks down along a two-dimensional fold locus $\mathcal{C}_{\mathrm{fold}}$. This loss of stability drives the system into a singular four-phase relaxation cycle $\Gamma_{\mathrm{rel}}$, providing a unified topological origin for intermittent turbulent bursting, nocturnal low-level jet acceleration, and sudden regime transitions between Weakly Stable (WSBL), Very Stable (VSBL), and Intermittent (IBL) states.

Finally, we translate these invariant geometric bounds into three operational model closures: an $H_{\max}$ sensible heat flux capacity limiter, a dynamic critical Richardson threshold $Ri_{\mathrm{fold}}(T_s, T_g)$ coupled to soil thermal inertia, and a dynamic scale height contraction formula $h_{\mathrm{eff}}$. This framework provides a path toward eliminating systemic nocturnal forecast biases in weather and climate models.
\end{abstract}

\noindent\textbf{Keywords:} Stable Boundary Layer, Geometric Singular Perturbation Theory, Invariant Manifolds, Fold Catastrophe, Intermittent Turbulence, Turbulence Closure Scheme

\newpage

% --- Main Sections ---
\input{intro}
\input{2}
\input{3}
\input{4}
\input{5}
\input{6}
\input{ConclusionsRoadMap}

% --- Appendices ---
\appendix
\input{A}
\input{B}
\input{C}

% --- Bibliography ---
\bibliographystyle{ametsoc2014}
\bibliography{paper1_references}

\end{document}

```
This clean hierarchy resolves the macro ordering issues, sets up a shared theorem counter relative to each section (Theorem 3.1, Definition 3.2), and configures the ametsoc2014 citation environment expected by AMS journals like *Journal of the Atmospheric Sciences*.  
