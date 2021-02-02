using CoexistenceHoles
using Test
import LinearAlgebra: norm

@testset "random_growthvector.jl" begin
    N = 8; μ = 0.1; σ = 0.1; # create growth vectors from these specs

    # create some vectors to play with
    r1 = random_growthvector(N, μ, σ, seed=1234);
    r2 = random_growthvector(N, μ, σ, seed=1234);
    r3 = random_growthvector(N, μ, σ, seed=1235);

    # check that the seed is reproducible
    @test r1 == r2
    @test r1 != r3


end

@testset "ransomize_growthvector.jl" begin
    r = [0.1, -0.3, 2.1, -1, 0.5];
    # create randomizations of r
    r_rand1 = randomize_growthvector(r, method="preserve_norm", seed=1234);
    r_rand2 = randomize_growthvector(r, method="preserve_norm", seed=1234);
    r_rand3 = randomize_growthvector(r, method="preserve_norm", seed=1235);

    @test r_rand1 == r_rand2 # reproducibility
    @test r_rand1 != r_rand3 # reproducibility
    @test norm(r_rand1) - norm(r) < 1e-10 # norm_preserved

    r_psign_samp1 = randomize_growthvector(r, method="preserve_sign_sample", seed=1234);
    r_psign_samp2 = randomize_growthvector(r, method="preserve_sign_sample", seed=1234);
    r_psign_samp3 = randomize_growthvector(r, method="preserve_sign_sample", seed=1235);

    @test r_psign_samp1 == r_psign_samp2 # reproducibility
    @test r_psign_samp1 != r_psign_samp3 # reproducibility
    @test sign.(r) == sign.(r_psign_samp1) # same signs
    @test isempty(filter(x -> !in(x, abs.(r)), abs.(r_psign_samp1))) # contains same values (perhaps different order)

    r_psign_shuf1 = randomize_growthvector(r, method="preserve_sign_shuffle", seed=1234);
    r_psign_shuf2 = randomize_growthvector(r, method="preserve_sign_shuffle", seed=1234);
    r_psign_shuf3 = randomize_growthvector(r, method="preserve_sign_shuffle", seed=1235);

    @test r_psign_shuf1 == r_psign_shuf2 # reproducibility
    @test r_psign_shuf1 != r_psign_shuf3 # reproducibility
    @test sign.(r) == sign.(r_psign_shuf1) # same signs
    @test isempty(filter(x -> !in(x, abs.(r)), abs.(r_psign_shuf1))) && isempty(filter(x -> !in(x, abs.(r_psign_shuf1)), abs.(r))) # both contain the values of the other (i.e. no new value introduced in the shuffle)

    r_samp1 = randomize_growthvector(r, method="sample", seed=1234);
    r_samp2 = randomize_growthvector(r, method="sample", seed=1234);
    r_samp3 = randomize_growthvector(r, method="sample", seed=1235);

    @test r_samp1 == r_samp2 # reproducibility
    @test r_samp1 != r_samp3 # reproducibility
    @test isempty(filter(x -> !in(x, abs.(r)), abs.(r_samp1))) # contains same values (perhaps different order)

    r_shuf1 = randomize_growthvector(r, method="shuffle", seed=1234);
    r_shuf2 = randomize_growthvector(r, method="shuffle", seed=1234);
    r_shuf3 = randomize_growthvector(r, method="shuffle", seed=1235);

    @test r_shuf1 == r_shuf2 # reproducibility
    @test r_shuf1 != r_shuf3 # reproducibility
    @test isempty(filter(x -> !in(x, abs.(r)), abs.(r_shuf1))) && isempty(filter(x -> !in(x, abs.(r_shuf1)), abs.(r))) # both contain the values of the other (i.e. no new value introduced in the shuffle)

end
