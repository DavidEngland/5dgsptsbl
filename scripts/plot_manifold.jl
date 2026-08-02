#!/usr/bin/env julia

include(joinpath(@__DIR__, "..", "src", "5DGSPTSBL.jl"))
using .FiveDGSPTSBL
using CairoMakie
using ComponentArrays
using DifferentialEquations

params = SBLParams()
u0 = ComponentArray(e_tilde = 0.5, q_theta = -0.01, S = 0.05, Ts = 285.0, Tg = 288.0)
problem = ODEProblem(gspt_5d_rhs!, u0, (0.0, 3600.0), params)
solution = solve(problem, Rodas5P(); saveat = 60.0)

figure = Figure(size = (900, 700))
axis = Axis(figure[1, 1], xlabel = "ẽ", ylabel = "qθ")
lines!(axis, solution[1, :], solution[2, :], color = :navy)

output_dir = joinpath(@__DIR__, "..", "paper", "figures")
mkpath(output_dir)
save(joinpath(output_dir, "manifold.png"), figure)

println("Saved manifold figure to ", joinpath(output_dir, "manifold.png"))