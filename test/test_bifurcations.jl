@testset "bifurcation helpers" begin
    params = SBLParams()
    cases99 = SBLParams(:cases99)
    sheba = SBLParams(:sheba)

    @test cases99.cm == 0.048
    @test cases99.cw == 0.029
    @test sheba.ctheta == 0.035
    @test sheba.ell_inf == 12.4

    ignition = transcritical_ignition_shear(280.0, 0.2, params)
    @test isfinite(ignition)
    @test ignition > 0

    cusp = tracking_codim2_points(SVector(0.0, 280.0), params).cusp
    @test cusp.exists
    @test cusp.residual == 0.0

    bt = tracking_codim2_points(SVector(0.5, 280.0), params).bogdanov_takens
    @test bt.exists
    @test all(isfinite, bt.state)
    @test isapprox(bt.trace, 0.0; atol = 1e-8)
    @test isapprox(bt.determinant, 0.0; atol = 1e-8)

    @test hysteresis_width(0.6, 1.0) > 0
    @test hysteresis_width(1.1, 1.0) == 0.0
end