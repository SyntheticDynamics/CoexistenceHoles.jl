using SafeTestsets

@safetestset "Create Growth Vector Tests" begin include("create_growth_vector_tests.jl") end
@safetestset "Create Community Matrix Tests" begin include("create_community_matrix_tests.jl") end
@safetestset "GLV Analysis Tests" begin include("GLV_analysis_tests.jl") end
@safetestset "Holes tests" begin include("holes_tests.jl") end
