using CoexistHypergraph
using Test

@testset "is_GLVlocallystable.jl" begin
    A1 = [-1     0       0       -0.148;
         0      -1      0       0;
         0      0.0997  -1      0;
         0.14   0       -0.05   -1];
    r1 = [0.1, -0.3, 2.1, -1];

    A2 = [-1     0       0       -0.148;
         0      -1      0       0;
         0      0.0997  -1      0;
         0.14   0       -0.05   -1];
    r2 = [0.13, 0.1, 0.1, 0.2];

    @test !is_GLVlocallystable(A1,r1)
    @test is_GLVlocallystable(A2, r2)


end

@testset "is_GLVpermanent.jl" begin
    A1 = [-1     0       0       -0.148;
         0      -1      0       0;
         0      0.0997  -1      0;
         0.14   0       -0.05   -1];
    r1 = [0.1, -0.3, 2.1, -1];

    A2 = [-1     0       0       -0.148;
         0      -1      0       0;
         0      0.0997  -1      0;
         0.14   0       -0.05   -1];
    r2 = [0.13, 0.1, 0.1, 0.2];

    @test !is_GLVpermanent(A1, r1)
    @test is_GLVpermanent(A2, r2)
end
