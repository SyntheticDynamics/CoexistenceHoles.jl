using CoexistHypergraph
using Test

@testset "create growth vector" begin
    N = 8; μ = 0.1; σ = 0.1; # create growth vectors from these specs
    r0 = random_growthvector(N, μ, σ);
    r1 = random_growthvector(N, μ, σ, seed=1234);
    r2 = random_growthvector(N, μ, σ, seed=1234);
    r3 = random_growthvector(N, μ, σ, seed=1235);

    # check that the seed is reproducible
    @test r1 != r0
    @test r1 == r2
    @test r1 != r3






end
