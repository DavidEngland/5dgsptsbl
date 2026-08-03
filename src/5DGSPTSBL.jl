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
include(joinpath("analysis", "bifurcations.jl"))
include(joinpath("physics", "scm.jl"))
include(joinpath("wsindy", "identification.jl"))

export SBLParams
export z_eff, mixing_length, h_sbl, stratification, eddy_diffusivity, bulk_drag_coef, bulk_heat_coef
export transcritical_ignition_shear
export gspt_5d_rhs!, fast_2d_rhs, shear_forcing, net_radiation
export fast_jacobian, fast_trace, jacobian_determinant, find_fold_locus, delta_sensitivity_check
export tracking_codim2_points, hysteresis_width
export SCMGrid, SCMParameters, scm_boundary_layer_depth, scm_interface_diffusivities, scm_rhs!
export identify_gspt_closures

end