
include("../src/create_hypergraph.jl")
include("../src/hypergraph_analysis.jl")

betti = [];
graphs = [];
for i = 1:20

    σA = rand()*5
    C = 0.9
    N = Int64(round(rand()*15+1))
    μ = rand()*3
    σr = rand()*1.5

    reg = 0
    max_dim  = 4

    A = random_communitymatrix(N, σA, C)
    r = random_growthvector(N, μ, σr)

    # H = assembly_hypergraph_GLV(A, r; method = "permanence", regularization = reg)
    H2 = assembly_hypergraph_GLV(A, r; method = "localstability", regularization = reg)


    # R = disassembly_hypergraph(H)

    betti_H = betti_hypergraph_ripscomplex(H; max_dim = max_dim)
    @show betti_H
    if betti_H != [1, 0, 0, 0, 0]
        @show "entered"
        graphs = [graphs, [H2]]
        betti = [betti, [betti]]
    end
end
