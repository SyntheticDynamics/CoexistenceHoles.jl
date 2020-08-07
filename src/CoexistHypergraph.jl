
module CoexistHypergraph

import LinearAlgebra: diagind, rank, pinv, eigvals, diagm, norm, diag
import StatsBase: sample
import Distributions: Uniform, Normal, Bernoulli, LogNormal
import ProgressMeter: @showprogress
import Convex: Variable, minimize, solve!
import SCS: Optimizer
import IterTools: reverse
import Ripser: ripser
import Combinatorics: combinations
import Random: seed!, rand, shuffle


include("create_hypergraph.jl")
include("hypergraph_analysis.jl")

export  random_communitymatrix,
        randomize_communitymatrix,
        random_growthvector,
        is_GLVlocallystable,
        is_GLVpermanent,
        randomize_growthvector,
        assembly_hypergraph_GLV,
        disassembly_hypergraph,
        betti_hypergraph_ripscomplex,
        read_hypergraph,
        hypergraph_subdivide,
        minimal_simplicial_complex

end
