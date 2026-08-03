@testset "scm helpers" begin
    params = SBLParams()
    grid = SCMGrid([10.0, 20.0, 40.0])

    @test grid.dz == [10.0, 15.0, 20.0]
    @test grid.z_half == [15.0, 30.0]

    e_tilde = [0.2, 0.25, 0.3]
    depth = scm_boundary_layer_depth(e_tilde, grid)
    diffusivities = scm_interface_diffusivities(e_tilde, grid, params)
    @test isfinite(depth)
    @test depth > 0
    @test length(diffusivities) == 2
    @test all(>(0), diffusivities)

    scm_params = SCMParameters(grid, params)
    u = vcat(e_tilde, fill(-0.01, 3), [1.0, 1.1, 1.2], [0.0, 0.1, 0.2], [280.0, 281.0, 282.0])
    du = similar(u)
    scm_rhs!(du, u, scm_params, 0.0)

    @test length(du) == length(u)
    @test all(isfinite, du)
    @test any(!iszero, du[4:end])
end