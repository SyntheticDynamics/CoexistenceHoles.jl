
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

H = read_hypergraph(joinpath(@__DIR__, "data/Empirical/Jonathan/H.dat"))
betti_hypergraph_ripscomplex_old(H)
CoexistHypergraph.betti_hypergraph_ripscomplex(H)


function betti_hypergraph_ripscomplex_old(H; max_dim = 3)
    # old function using Ripser library: https://github.com/mtsch/Ripser.jl#master
    if length(H) == 0
        return zeros(max_dim + 1)
    else

        G = hypergraph_subdivide(H; expansion = false)
        # build distance matrix to give as input to Ripser.
        M = 2.0*ones(length(H), length(H))
        [ M[g[1], g[2]] = 1 for g in G ]

        #call Ripser
        barcodes = ripser(M; dim_max = max_dim, threshold = 1.5)
        # interpret the outout. Barcodes is an array of tuples of dim = max_dim + 1.
        # All tuples where the second entry is Inf are the persistent ones.
        # Betti numbers just count the number of those persistent ones.
        betti = [ count(x -> x[2] .== Inf, barcodes[i]) for i in 1:length(barcodes)]

        return betti
    end
end
