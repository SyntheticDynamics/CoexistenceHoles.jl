using CoexistHypergraph
using Test
import LinearAlgebra: norm

@testset "create growth vector" begin
    N = 8; μ = 0.1; σ = 0.1; # create growth vectors from these specs

    # create some vectors to play with
    r0 = random_growthvector(N, μ, σ);
    r1 = random_growthvector(N, μ, σ, seed=1234);
    r2 = random_growthvector(N, μ, σ, seed=1234);
    r3 = random_growthvector(N, μ, σ, seed=1235);

    # check that the seed is reproducible
    @test r1 != r0
    @test r1 == r2
    @test r1 != r3

    # create randomizations of r1
    r_rand1 = randomize_growthvector(r1, method="preserve_norm", seed=1234);
    r_rand2 = randomize_growthvector(r1, method="preserve_norm", seed=1234);
    r_rand3 = randomize_growthvector(r1, method="preserve_norm", seed=1235);
    r_psign_samp1 = randomize_growthvector(r_rand1, method="preserve_sign_sample", seed=1234);
    r_psign_samp2 = randomize_growthvector(r_rand1, method="preserve_sign_sample", seed=1234);
    r_psign_samp3 = randomize_growthvector(r_rand1, method="preserve_sign_sample", seed=1235);
    r_psign_shuf1 = randomize_growthvector(r_rand1, method="preserve_sign_shuffle", seed=1234);
    r_psign_shuf2 = randomize_growthvector(r_rand1, method="preserve_sign_shuffle", seed=1234);
    r_psign_shuf3 = randomize_growthvector(r_rand1, method="preserve_sign_shuffle", seed=1235);
    r_samp1 = randomize_growthvector(r_rand1, method="sample", seed=1234);
    r_samp2 = randomize_growthvector(r_rand1, method="sample", seed=1234);
    r_samp3 = randomize_growthvector(r_rand1, method="sample", seed=1235);
    r_shuf1 = randomize_growthvector(r_rand1, method="shuffle", seed=1234);
    r_shuf2 = randomize_growthvector(r_rand1, method="shuffle", seed=1234);
    r_shuf3 = randomize_growthvector(r_rand1, method="shuffle", seed=1235);

    # check that the seed is reproducible
    @test r_rand1 == r_rand2
    @test r_rand1 != r_rand3
    @test r_psign_samp1 == r_psign_samp2
    @test r_psign_samp1 != r_psign_samp3
    @test r_psign_shuf1 == r_psign_shuf2
    @test r_psign_shuf1 != r_psign_shuf3
    @test r_shuf1 == r_shuf2
    @test r_shuf1 != r_shuf3
    @test r_samp1 == r_samp2
    @test r_samp1 != r_samp3

    # test some expected invariant properties from the above functions
    @test norm(r_rand1) - norm(r1) < 1e-10 # norm_preserved
    @test sign.(r_rand1) == sign.(r_psign_samp1) # same signs
    @test sign.(r_rand1) == sign.(r_psign_shuf1) # same signs
    @test isempty(filter(x -> !in(x, abs.(r_rand1)), abs.(r_psign_samp1))) # contains same values (perhaps different order)
    @test isempty(filter(x -> !in(x, abs.(r_rand1)), abs.(r_samp1))) # contains same values (perhaps different order)
    @test isempty(filter(x -> !in(x, abs.(r_rand1)), abs.(r_shuf1))) && isempty(filter(x -> !in(x, abs.(r_shuf1)), abs.(r_rand1))) # both contain the values of the other
    @test isempty(filter(x -> !in(x, abs.(r_rand1)), abs.(r_psign_shuf1))) && isempty(filter(x -> !in(x, abs.(r_psign_shuf1)), abs.(r_rand1))) # both contain the values of the other

end

@testset "create community matrix" begin
    @test 1==1

end
