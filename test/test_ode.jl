@testset "ode smoke" begin
    params = SBLParams()
    u0 = [0.5, -0.01, 0.05, 285.0, 288.0]
    du = similar(u0)
    gspt_5d_rhs!(du, u0, params, 0.0)
    @test length(du) == 5
    @test isfinite(du[1])
end