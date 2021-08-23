using BenchmarkTools
H = read_hypergraph("/Users/aaronkelley/.julia/dev/CoexistenceHoles.jl/test/test_data/Lagoon of Venice/Hp.dat")

@benchmark begin
    f = betti_hypergraph_ripscomplex(H; max_dim=4)
end

@benchmark begin
    hypergraph_subdivide(H)
end;


@time begin
    G = hypergraph_subdivide(H; expansion = false);
end;

@time begin
    M = 2.0*ones(length(H), length(H));
    [ M[g[1], g[2]] = 1 for g in G ];
    [ M[g[2], g[1]] = 1 for g in G ];
    M[diagind(M)] .= 0;
end;

@time begin
    flt = Rips(M; threshold=1.5,sparse=true)
end;

@time begin
    barcodes = ripserer(flt; dim_max = 4)
end;

@time begin
    betti = [ count(x -> x[2] .== Inf, barcodes[i]) for i in 1:length(barcodes)]
end;


function betti_hypergraph_ripscomplex(H; max_dim = 3)

    if length(H) == 0
        return Int.(zeros(max_dim + 1))
    elseif length(H) == 1
        return Int.(vcat(1, zeros(max_dim)))
    end

    _max_dim = min(max_dim, length(H) - 2);

    G = hypergraph_subdivide(H; expansion = false)
    # build distance matrix to give as input to Ripserer.
    M = 2.0*ones(length(H), length(H))
    [ M[g[1], g[2]] = 1 for g in G ]
    [ M[g[2], g[1]] = 1 for g in G ]
    M[diagind(M)] .= 0;

    #call Ripser
    flt = Rips(M; threshold=1, sparse=true)
    barcodes = ripserer(flt; dim_max = _max_dim)
    # interpret the outout. Barcodes is an array of tuples of dim = max_dim + 1.
    # All tuples where the second entry is Inf are the persistent ones.
    # Betti numbers just count the number of those persistent ones.
    betti = [ count(x -> x[2] .== Inf, barcodes[i]) for i in 1:length(barcodes)]

    padding = (max_dim+1) - length(betti);
    return vcat(betti, Int.(zeros(padding)))


    ## old function using Ripser library: https://github.com/mtsch/Ripser.jl#master
    # if length(H) == 0
    #     return zeros(max_dim + 1)
    # else
    #
    #     G = hypergraph_subdivide(H; expansion = false)
    #     # build distance matrix to give as input to Ripser.
    #     M = 2.0*ones(length(H), length(H))
    #     [ M[g[1], g[2]] = 1 for g in G ]
    #
    #     #call Ripser
    #     barcodes = ripser(M; dim_max = max_dim, threshold = 1.5)
    #     # interpret the outout. Barcodes is an array of tuples of dim = max_dim + 1.
    #     # All tuples where the second entry is Inf are the persistent ones.
    #     # Betti numbers just count the number of those persistent ones.
    #     betti = [ count(x -> x[2] .== Inf, barcodes[i]) for i in 1:length(barcodes)]
    #
    #     return betti
    # end
end
