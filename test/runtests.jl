using SafeTestsets

@safetestset "Create Growth Vector Tests" begin include("create_growth_vector_tests.jl") end
@safetestset "Create Community Matrix Tests" begin include("create_community_matrix_tests.jl") end
