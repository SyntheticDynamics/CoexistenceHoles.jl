
include("../src/create_hypergraph.jl")
include("../src/hypergraph_analysis.jl")

σA = 0.1
C = 0.1
N = 8
μ = 0.3
σr = 0.2

reg = 0
max_dim  = 4

A = random_communitymatrix(N, σA, C)
r = random_r_vector(N, μ, σr)

H = coexistence_hypergraphGLV(A, r; method = "permanence", regularization = reg)
H = coexistence_hypergraphGLV(A, r; method = "localstability", regularization = reg)


R = relaxed_missing_edges(H)

betti_H = betti_hypergraph_ripscomplex(H; max_dim = max_dim)
