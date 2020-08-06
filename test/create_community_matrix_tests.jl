using CoexistHypergraph
using Test

@testset "random_communitymatrix.jl" begin
    N = 8; σ = 0.1; C = 0.1;
    A = random_communitymatrix(N, σ, C)
    @test 1==1
end

@testset "randomize_communitymatrix.jl" begin
    @test 1==1
end
