#!/usr/bin/env julia
# scripts/plot_manifold.jl

include(joinpath(@__DIR__, "..", "src", "5DGSPTSBL.jl"))
using .FiveDGSPTSBL
using CairoMakie
using ComponentArrays
using DifferentialEquations

params = SBLParams()
u0 = ComponentArray(e_tilde=0.5, q_theta=-0.01, S=0.05, Ts=285.0, Tg=288.0)
problem = ODEProblem(gspt_5d_rhs!, u0, (0.0, 3600.0), params)

# Explicit solver tolerances and dtmin prevent dt <= dt_epsilon warnings
# during stiff fast-slow transitions along the fold knee
solution = solve(
    problem,
    Rodas5P();
    saveat=60.0,
    reltol=1e-6,
    abstol=1e-8,
    dtmin=1e-12
)

# Extract states from saved ComponentArray snapshots.
e_tilde = getproperty.(solution.u, :e_tilde)
q_theta = getproperty.(solution.u, :q_theta)

figure = Figure(size=(900, 700), fontsize=14)
axis = CairoMakie.Axis(
    figure[1, 1],
    xlabel="ẽ",
    ylabel="qθ",
    title="5D GSPT SBL Phase Space Trajectory"
)

lines!(axis, e_tilde, q_theta, color=:navy, linewidth=2)

output_dir = joinpath(@__DIR__, "..", "paper", "figures")
mkpath(output_dir)
output_path = joinpath(output_dir, "manifold.png")
save(output_path, figure)

println("Saved manifold figure to ", output_path)