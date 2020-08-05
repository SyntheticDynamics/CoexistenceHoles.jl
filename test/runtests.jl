using ecovivo
using Test

@testset "ecovivo.jl" begin
    # Write your tests here.
    A = random_communitymatrix(8, 0.1, 0.1)
    r = random_r_vector(8, 0.1, 0.1)

    assembly_hypergraph(A, r; method = "permanence", regularization = 0)
end
