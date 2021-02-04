using FileIO, JLD2
using CoexistenceHoles
using Test

betti = FileIO.load(joinpath(@__DIR__, "test_keys/betti_checks.jld2"), "betti")


@testset "ripserer_tests.jl" begin
    for f in keys(betti)
        H = read_hypergraph(joinpath(@__DIR__, "test_data", f, "Hp.dat"))
        test_betti = betti_hypergraph_ripscomplex(H; max_dim = 4)
        @test test_betti==betti[f]
    end
end
