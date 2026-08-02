#!/usr/bin/env julia

include(joinpath(@__DIR__, "..", "src", "5DGSPTSBL.jl"))
using .FiveDGSPTSBL
using CairoMakie
using ComponentArrays
using DifferentialEquations
using LinearAlgebra
using StaticArrays

function solve_cases99(params::SBLParams)
	u0 = ComponentArray(e_tilde = 0.5, q_theta = -0.01, S = 0.05, Ts = 285.0, Tg = 288.0)
	tspan = (0.0, 12.0)
	problem = ODEProblem(gspt_5d_rhs!, u0, tspan, params)
	return solve(problem, Rodas5P(); saveat = 1 / 60, abstol = 1e-8, reltol = 1e-6,
		maxiters = 10^7)
end

function plot_cases99(solution, params::SBLParams)
	times = solution.t
	e_tilde = solution[1, :]
	q_theta = solution[2, :]
	S = solution[3, :]
	Ts = solution[4, :]
	Tg = solution[5, :]

	fold_grid_e = range(minimum(e_tilde), stop = maximum(e_tilde), length = 60)
	fold_grid_q = range(minimum(q_theta), stop = maximum(q_theta), length = 60)
	determinant_grid = [jacobian_determinant(SVector(e, q), SVector(S[i], Ts[i]), params) for e in fold_grid_e, q in fold_grid_q]

	figure = Figure(size = (1400, 1100))
	axis_a = Axis(figure[1, 1], xlabel = "t (h)", ylabel = "state")
	lines!(axis_a, times, e_tilde, color = :steelblue, label = "ẽ")
	lines!(axis_a, times, q_theta, color = :darkorange, label = "qθ")
	axislegend(axis_a, position = :rb)

	axis_b = Axis(figure[1, 2], xlabel = "t (h)", ylabel = "temperature")
	lines!(axis_b, times, Ts, color = :firebrick, label = "Ts")
	lines!(axis_b, times, Tg, color = :seagreen, label = "Tg")
	axislegend(axis_b, position = :rb)

	axis_c = Axis(figure[2, 1], xlabel = "ẽ", ylabel = "qθ")
	contour!(axis_c, fold_grid_e, fold_grid_q, determinant_grid'; levels = [0.0], color = :black)
	lines!(axis_c, e_tilde, q_theta, color = :midnightblue, linewidth = 2)

	axis_d = Axis(figure[2, 2], xlabel = "t (h)", ylabel = "det(J_fast)")
	determinant_series = [jacobian_determinant(SVector(e_tilde[i], q_theta[i]), SVector(S[i], Ts[i]), params) for i in eachindex(times)]
	lines!(axis_d, times, determinant_series, color = :black)
	hlines!(axis_d, [0.0], color = :red, linestyle = :dash)

	return figure
end

params = SBLParams(cm = 0.05, cw = 0.03, ctheta = 0.02, Ctheta = 0.05, eps1 = 0.002, eps2 = 0.05)
solution = solve_cases99(params)
figure = plot_cases99(solution, params)

output_dir = joinpath(@__DIR__, "..", "paper", "figures")
mkpath(output_dir)
save(joinpath(output_dir, "cases99_manifold.png"), figure)

println("Saved CASES-99 figure to ", joinpath(output_dir, "cases99_manifold.png"))