@testset "richardson fold helpers" begin
    R_net = 120.0
    G = 60.0
    H_max = 300.0

    Pi = cooling_parameter(R_net, G, H_max)
    @test isapprox(Pi, 0.2; atol = 1e-12)

    Ri_fold = ri_fold_dynamic(R_net, G, H_max)
    @test isapprox(Ri_fold, 0.275; atol = 1e-12)

    @test ri_fold_from_pi(0.0) == 0.22
    @test ri_fold_from_pi(0.95) > ri_fold_from_pi(0.5)

    beta_h = 5.0
    H = 80.0
    Ri_flux = ri_fold_flux_form(R_net, G, H; beta_h = beta_h)
    @test isfinite(Ri_flux)
    @test Ri_flux > 0
end
