
module ecovivo

import LinearAlgebra: diagind, rank, pinv, eigvals, diagm
import StatsBase: sample
import Distributions: Uniform, Normal, Bernoulli, LogNormal
import ProgressMeter: @showprogress
import Convex: Variable, minimize, solve!
import SCS: Optimizer
import IterTools: reverse
import Ripser: ripser
import Combinatorics: combinations


include("create_hypergraph.jl")
include("hypergraph_analysis.jl")

export random_communitymatrix, random_r_vector, assembly_hypergraphGLV, disassembly_hypergraph, betti_hypergraph_ripscomplex

end
