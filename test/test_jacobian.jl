@testset "jacobian smoke" begin
    params = SBLParams()
    u_fast = SVector(0.5, -0.01)
    u_slow = SVector(0.05, 285.0)
    J = fast_jacobian(u_fast, u_slow, params)
    @test size(J) == (2, 2)
    @test isfinite(jacobian_determinant(u_fast, u_slow, params))
end