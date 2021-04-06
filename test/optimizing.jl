using BenchmarkTools
H = read_hypergraph("/Users/aaronkelley/.julia/dev/CoexistenceHoles.jl/test/test_data/Lagoon of Venice/Hp.dat")

@benchmark begin
    betti_hypergraph_ripscomplex(H; max_dim=4)
end;

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
