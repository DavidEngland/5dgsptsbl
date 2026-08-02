using Test
using ForwardDiff
using StaticArrays

include(joinpath("..", "src", "5DGSPTSBL.jl"))
using .FiveDGSPTSBL

include("test_closures.jl")
include("test_jacobian.jl")
include("test_ode.jl")