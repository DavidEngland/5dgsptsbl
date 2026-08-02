@testset "closures" begin
    params = SBLParams()
    @test z_eff(0.0, params) > 0
    @test eddy_diffusivity(mixing_length(z_eff(10.0, params), params), 1e-6) > 0
    @test ForwardDiff.derivative(x -> z_eff(x, params), 1.0) == 1.0
    @test ForwardDiff.derivative(x -> mixing_length(x, params), 1.0) isa Real
    @test ForwardDiff.derivative(x -> h_sbl(x, params), 1.0) == params.L_e
    @test ForwardDiff.derivative(x -> stratification(285.0, x, params), 1.0) isa Real
    @test ForwardDiff.derivative(x -> eddy_diffusivity(x, 1.0), 1.0) == 1.0
    @test ForwardDiff.derivative(x -> bulk_drag_coef(SBLParams(z1 = x)), 10.0) isa Real
    @test ForwardDiff.derivative(x -> bulk_heat_coef(SBLParams(z1 = x)), 10.0) isa Real
end