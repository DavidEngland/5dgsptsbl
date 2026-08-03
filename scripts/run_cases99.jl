#!/usr/bin/env julia
# scripts/run_cases99.jl

include(joinpath(@__DIR__, "..", "src", "5DGSPTSBL.jl"))
using .FiveDGSPTSBL
using CairoMakie
using ComponentArrays
using DifferentialEquations
using StaticArrays

const CASES99_TSPAN = (0.0, 43200.0)
const CASES99_SAVEAT = 60.0
const PLOT_PX_PER_UNIT = 300.0 / 72.0

function solve_cases99(params::SBLParams)
	u0 = ComponentArray(e_tilde = 0.5, q_theta = -0.01, S = 0.05, Ts = 285.0, Tg = 288.0)
	problem = ODEProblem(gspt_5d_rhs!, u0, CASES99_TSPAN, params)
	return solve(
		problem,
		RadauIIA5(autodiff = true);
		saveat = CASES99_SAVEAT,
		reltol = 1e-8,
		abstol = 1e-8,
		dtmin = 1e-12,
		maxiters = 10_000_000,
	)
end

function extract_states(solution)
	t_seconds = solution.t
	t_hours = t_seconds ./ 3600
	e_tilde = solution[1, :]
	q_theta = solution[2, :]
	S = solution[3, :]
	Ts = solution[4, :]
	Tg = solution[5, :]
	return t_seconds, t_hours, e_tilde, q_theta, S, Ts, Tg
end

function determinant_series(e_tilde, q_theta, S, Ts, params)
	return [
		jacobian_determinant(SVector(e_tilde[i], q_theta[i]), SVector(S[i], Ts[i]), params)
		for i in eachindex(e_tilde)
	]
end

function plot_cases99_figure(solution, params::SBLParams)
	t_seconds, t_hours, e_tilde, q_theta, S, Ts, Tg = extract_states(solution)
	det_J = determinant_series(e_tilde, q_theta, S, Ts, params)

	set_theme!(Theme(font = "CMU Serif", fontsize = 16))

	fig = Figure(size = (2400, 1800))

	ax1 = CairoMakie.Axis(fig[1, 1], xlabel = "e_tilde", ylabel = "q_theta", title = "(a) Fast Phase Plane")
	lines!(ax1, e_tilde, q_theta, color = :navy, linewidth = 2)

	ax2 = CairoMakie.Axis(fig[1, 2], xlabel = "T_s (K)", ylabel = "T_g (K)", title = "(b) Thermal Slow Manifold")
	lines!(ax2, Ts, Tg, color = :firebrick, linewidth = 2)

	ax3 = CairoMakie.Axis3(fig[2, 1], xlabel = "e_tilde", ylabel = "q_theta", zlabel = "S", title = "(c) 3D Trajectory")
	lines!(ax3, e_tilde, q_theta, S, color = :steelblue, linewidth = 2)

	ax4 = CairoMakie.Axis(fig[2, 2], xlabel = "t (hours)", ylabel = "det(J_fast)", title = "(d) Fast Jacobian Determinant")
	lines!(ax4, t_hours, det_J, color = :black, linewidth = 2)
	hlines!(ax4, [0.0], color = :red, linestyle = :dash)

	return fig, det_J
end

function plot_manifold_projection(solution)
	_, _, e_tilde, q_theta, _, _, _ = extract_states(solution)

	set_theme!(Theme(font = "CMU Serif", fontsize = 18))

	fig = Figure(size = (2400, 1800))
	ax = CairoMakie.Axis(fig[1, 1], xlabel = "e_tilde", ylabel = "q_theta", title = "Fast Fiber Relaxation onto M_0^+")
	lines!(ax, e_tilde, q_theta, color = :midnightblue, linewidth = 3)
	scatter!(ax, e_tilde[1:20:end], q_theta[1:20:end], color = :orange, markersize = 8)

	return fig
end

function main()
	params = SBLParams(:cases99)
	solution = solve_cases99(params)

	fig_cases99, det_J = plot_cases99_figure(solution, params)
	fig_manifold = plot_manifold_projection(solution)

	output_dir = joinpath(@__DIR__, "..", "paper", "figures")
	mkpath(output_dir)

	cases99_path = joinpath(output_dir, "cases99_manifold.png")
	manifold_path = joinpath(output_dir, "manifold.png")

	save(cases99_path, fig_cases99; px_per_unit = PLOT_PX_PER_UNIT)
	save(manifold_path, fig_manifold; px_per_unit = PLOT_PX_PER_UNIT)

	println("Saved CASES-99 figure to ", cases99_path)
	println("Saved manifold figure to ", manifold_path)
	println("det(J_fast) range: [", minimum(det_J), ", ", maximum(det_J), "]")
end

main()