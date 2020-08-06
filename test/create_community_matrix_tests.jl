using CoexistHypergraph
using Test

@testset "random_communitymatrix.jl" begin
    N = 8; σ = 0.1; p = 0.1;
    A1 = random_communitymatrix(N, σ, p, seed=1234);
    A2 = random_communitymatrix(N, σ, p, seed=1234);
    A3 = random_communitymatrix(N, σ, p, seed=1235);
    @test A1 == A2
    @test A1 != A3
end

@testset "randomize_communitymatrix.jl" begin
    A = [-1     0       0       -0.148;
         0      -1      0       0;
         0      0.0997  -1      0;
         0.14   0       -0.05   -1]
    A_shuf1 = randomize_communitymatrix(A, method="shuffle", seed=1234);
    A_shuf2 = randomize_communitymatrix(A, method="shuffle", seed=1234);
    A_shuf3 = randomize_communitymatrix(A, method="shuffle", seed=1235);

    @test A_shuf1 == A_shuf2
    @test A_shuf1 != A_shuf3
    @test isempty(filter(x -> !in(x, abs.(A_shuf1)), abs.(A))) && isempty(filter(x -> !in(x, abs.(A)), abs.(A_shuf1)))

    A_samp1 = randomize_communitymatrix(A, method="sample", seed=1234);
    A_samp2 = randomize_communitymatrix(A, method="sample", seed=1234);
    A_samp3 = randomize_communitymatrix(A, method="sample", seed=125);

    @test A_samp1 == A_samp2
    @test A_samp1 != A_samp3
    @test isempty(filter(x -> !in(x, abs.(A)), abs.(A_samp1)))

    A_pshuf1 = randomize_communitymatrix(A, method="preserve_sign_shuffle", seed=1234);
    A_pshuf2 = randomize_communitymatrix(A, method="preserve_sign_shuffle", seed=1234);
    A_pshuf3 = randomize_communitymatrix(A, method="preserve_sign_shuffle", seed=125);

    @test A_pshuf1 == A_pshuf2
    @test A_pshuf1 != A_pshuf3
    @test sign.(A) == sign.(A_pshuf1)
    @test isempty(filter(x -> !in(x, abs.(A_pshuf1)), abs.(A))) && isempty(filter(x -> !in(x, abs.(A)), abs.(A_pshuf1)))

    A_psamp1 = randomize_communitymatrix(A, method="preserve_sign_sample", seed=1234);
    A_psamp2 = randomize_communitymatrix(A, method="preserve_sign_sample", seed=1234);
    A_psamp3 = randomize_communitymatrix(A, method="preserve_sign_sample", seed=125);

    @test A_samp1 == A_samp2
    @test A_samp1 != A_samp3
    @test isempty(filter(x -> !in(x, abs.(A)), abs.(A_psamp1)))



end
