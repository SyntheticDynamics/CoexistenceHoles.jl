using CoexistHypergraph
using Test

@testset "is_GLVlocallystable.jl" begin
    A = [-1     0       0       -0.148;
         0      -1      0       0;
         0      0.0997  -1      0;
         0.14   0       -0.05   -1];
    r = [0.1, -0.3, 2.1, -1, 0.5];

end

@testset "is_GLVpermanent.jl" begin
    @test 1==1
end
