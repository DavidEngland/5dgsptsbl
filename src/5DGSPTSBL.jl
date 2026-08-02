module FiveDGSPTSBL

using ComponentArrays
using DifferentialEquations
using ForwardDiff
using LinearAlgebra
using StaticArrays

include("types.jl")
include(joinpath("physics", "closures.jl"))
include(joinpath("physics", "rhs.jl"))
include(joinpath("analysis", "jacobian.jl"))
include(joinpath("wsindy", "identification.jl"))

export SBLParams
export z_eff, mixing_length, h_sbl, stratification, eddy_diffusivity, bulk_drag_coef, bulk_heat_coef
export gspt_5d_rhs!, fast_2d_rhs
export fast_jacobian, jacobian_determinant, find_fold_locus, delta_sensitivity_check
export identify_gspt_closures

end