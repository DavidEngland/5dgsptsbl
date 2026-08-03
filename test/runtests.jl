using Test
using ForwardDiff
using StaticArrays
using LinearAlgebra
using Statistics

include(joinpath("..", "src", "5DGSPTSBL.jl"))
using .FiveDGSPTSBL

include("test_closures.jl")
include("test_bifurcations.jl")
include("test_delta_sensitivity.jl")
include("test_jacobian.jl")
include("test_ode.jl")
include("test_scm.jl")