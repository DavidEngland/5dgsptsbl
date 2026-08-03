@testset "Delta regularization sensitivity" begin
    deltas = [1e-6, 1e-5, 1e-4]
    fold_points = SVector{2, Float64}[]
    leading_eigenvalues = Float64[]

    Ts = 280.0
    q_theta = -0.005
    e_tilde_test = 0.2
    shear_test = 0.05
    slow_state = SVector(shear_test, Ts)
    u_fast = SVector(e_tilde_test, q_theta)

    for delta_value in deltas
        params = SBLParams(delta = delta_value)

        det_J = jacobian_determinant(u_fast, slow_state, params)
        @test isfinite(det_J)

        eigenvalues = eigvals(Matrix(fast_jacobian(u_fast, slow_state, params)))
        @test all(isfinite, real.(eigenvalues))
        @test all(isfinite, imag.(eigenvalues))
        push!(leading_eigenvalues, maximum(real.(eigenvalues)))

        fold_point = find_fold_locus(slow_state, params)
        @test all(isfinite, fold_point)
        @test isapprox(jacobian_determinant(fold_point, slow_state, params), 0.0; atol = 1e-8)
        push!(fold_points, fold_point)
    end

    fold_reference = fold_points[1]
    fold_spread = maximum(norm.(fold_points .- Ref(fold_reference))) /
                  max(norm(fold_reference), eps())
    eig_spread = (maximum(leading_eigenvalues) - minimum(leading_eigenvalues)) /
                 max(mean(abs.(leading_eigenvalues)), eps())

    @test fold_spread < 1e-3
    @test eig_spread < 1e-3
    @test delta_sensitivity_check(slow_state, SBLParams(), deltas) < 1e-3
end