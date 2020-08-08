var documenterSearchIndex = {"docs":
[{"location":"examples/#Examples","page":"Examples","title":"Examples","text":"","category":"section"},{"location":"glossary/#Function-Glossary","page":"Function Glossary","title":"Function Glossary","text":"","category":"section"},{"location":"glossary/","page":"Function Glossary","title":"Function Glossary","text":"Pages=[\"glossary.md\"]","category":"page"},{"location":"glossary/","page":"Function Glossary","title":"Function Glossary","text":"Modules = [CoexistHypergraph]","category":"page"},{"location":"glossary/#CoexistHypergraph.assembly_hypergraph_GLV-Tuple{Array{#s18,2} where #s18<:Real,Array{#s16,1} where #s16<:Real}","page":"Function Glossary","title":"CoexistHypergraph.assembly_hypergraph_GLV","text":"assemblyhypergraphGLV(A,r; <keyword arguments>) Computes the assembly hypergraph for (A,r).\n\nArguments\n\nA::Array{<:Real,2}: community matrix\nr::Array{<:Real, 1}: growth vector\nmethod::String=\"permanence\": will return a randomized growthvector using one of the following methods\n\"permanence\": uses the is_GLVpermantent(@ref) to determine interspecies coexistance\n\"localstability\": uses the is_GLVlocallystable(@ref) to determine interspecies coexistance\nregularization::Real=0:\n\nOutputs\n\nhypergraph::Array{Array{Int64,1},1}: array of hyper edges: species in edge => species coexist\n\n\n\n\n\n","category":"method"},{"location":"glossary/#CoexistHypergraph.betti_hypergraph_ripscomplex-Tuple{Any}","page":"Function Glossary","title":"CoexistHypergraph.betti_hypergraph_ripscomplex","text":"Computes Betti numbers of hypergraph. Based on computing the hypergraph subdivision without expansion, which returns the inclusion graph\n\n\n\n\n\n","category":"method"},{"location":"glossary/#CoexistHypergraph.is_GLVlocallystable-Tuple{Array{#s14,2} where #s14<:Real,Array{#s15,1} where #s15<:Real}","page":"Function Glossary","title":"CoexistHypergraph.is_GLVlocallystable","text":"is_GLVlocallystable(A, r)\n\nComputes if the pair (A,r) has a feasible interior equilibrium that is stable.\n\nArguments\n\nA::Array{Real,2}: community matrix\nr::Array{Real, 1}: growth vector\n\nOutputs\n\nstability::Bool: true = stable, false = not stable\n\n\n\n\n\n","category":"method"},{"location":"glossary/#CoexistHypergraph.is_GLVpermanent-Tuple{Array{#s21,2} where #s21<:Real,Array{#s22,1} where #s22<:Real}","page":"Function Glossary","title":"CoexistHypergraph.is_GLVpermanent","text":"is_GLVpermanent(A, r; <keyword arguments>)\n\nComputes permanence of the pair (A,r) using Jansen's criterion of mutual invasibility. is_permanente(A,r;) -> Boolean\n\nArguments\n\nA::Array{<:Real,2}: community matrix\nr::Array{<:Real, 1}: growth vector\nregularization::Real=0:\nz_tolerance::Real=-1e-60:\niterations::Integer=1e4:\n\nOutputs\n\npermanence::Bool: true = permanent, false = not permanent\n\n\n\n\n\n","category":"method"},{"location":"glossary/#CoexistHypergraph.minimal_simplicial_complex-Tuple{Any}","page":"Function Glossary","title":"CoexistHypergraph.minimal_simplicial_complex","text":"Computes the minimal simplicial complex containig the hypergraph H\n\n\n\n\n\n","category":"method"},{"location":"glossary/#CoexistHypergraph.missing_edges-Tuple{Any}","page":"Function Glossary","title":"CoexistHypergraph.missing_edges","text":"Computes missing edges of hypergraph H\n\n\n\n\n\n","category":"method"},{"location":"glossary/#CoexistHypergraph.random_communitymatrix-Tuple{Real,Real,Real}","page":"Function Glossary","title":"CoexistHypergraph.random_communitymatrix","text":"random_communitymatrix(N, σ, p)\n\nGenerates a random community matrix (the \"A\" matrix in the generalized Lotka-Voltera equation). entries according to a Bernoulli distribution with success rate parameter, p (the entries that are not \"populated\" are set to 0)\n\nArguments\n\nN::Real: dimension of returned square matrix (N x N)\nσ::Real: standard deviation of normal distribution used to generate each entry (μ = 0)\np::Real: success rate of Bernoulli distribution used to populate the returned matrix\nseed::Union{Nothing, <:Int}=nothing: if specified, this seed will be used in the random number generator, allowing reproducibility\n\nOutput\n\ncommunity_matrix::Array{<:Real,2}\n\nSee also: randomize_communitymatrix\n\n\n\n\n\n","category":"method"},{"location":"glossary/#CoexistHypergraph.random_growthvector-Tuple{Any,Any,Any}","page":"Function Glossary","title":"CoexistHypergraph.random_growthvector","text":"random_growthvector(N, μ, σ; seed=nothing)\n\nGenerates a random growth vector (the \"r\" vector in the generalized Lotka-Voltera  equation)\n\nArguments\n\nN::Real: length of returned growth vector\nμ::Real: mean of LogNormal distribution used to generate each value\nσ::Real: standard deviation of LogNormal distribution used to generate each value\nseed::Union{Nothing, <:Int}=nothing: if specified, this seed will be used in the random number generator, allowing reproducibility\n\nOutput\n\ngrowth_vector::Array{<:Real,1}\n\nSee also: randomize_growthvector\n\n\n\n\n\n","category":"method"},{"location":"glossary/#CoexistHypergraph.randomize_communitymatrix-Tuple{Array{#s14,2} where #s14<:Real}","page":"Function Glossary","title":"CoexistHypergraph.randomize_communitymatrix","text":"randomize_communitymatrix(A; <keyword arguments>)\n\nArguments\n\nr::Array{<:Real,2}: growth vector (this can be generated randomly by random_growthvector)\nmethod::String=\"shuffle\": will return a randomized community matrix using one of the following methods\n\"shuffle\": shuffles all of the entries except for the ones on the diagonals\n\"preserve_sign_shuffle\": same as \"shuffle\" but the signs are not modified\nseed::Union{Nothing, <:Int}=nothing: if specified, this seed will be used in the random number generator, allowing reproducibility\n\nOutput\n\ncommunity_matrix::Array{<:Real,2}\n\nSee also: random_communitymatrix\n\n\n\n\n\n","category":"method"},{"location":"glossary/#CoexistHypergraph.randomize_growthvector-Tuple{Array{#s19,1} where #s19<:Real}","page":"Function Glossary","title":"CoexistHypergraph.randomize_growthvector","text":"randomize_growthvector(r; <keyword arguments>)\n\nArguments\n\nr::Array{<:Real,1}: growth vector (this can be generated randomly by random_growthvector)\nmethod::String=\"preserve_norm\": will return a randomized growthvector using one of the following methods\n\"preserve_norm\": generated using a normal distribution for each entry, and then scaled to have the same norm as growth vector input (r)\n\"shuffle\": randomly permute growth vector input (r)\n\"sample\": randomly sample (with replacement) entries of growth vector input (r)\n\"preserve_sign_shuffle\": same as \"shuffle\" but the signs are not modified\n\"preserve_sign_sample\": same as \"sample\" but the signs are not modified\nseed::Union{Nothing, <:Int}=nothing: if specified, this seed will be used in the random number generator, allowing reproducibility\n\nOutput\n\ngrowth_vector::Array{<:Real,1}\n\nSee also: random_growthvector\n\n\n\n\n\n","category":"method"},{"location":"glossary/#CoexistHypergraph.save_hypergraph_dat-Tuple{String,Array{Array{Int64,1},1}}","page":"Function Glossary","title":"CoexistHypergraph.save_hypergraph_dat","text":"savehypergraphdat(file, H)\n\nSaves the hypergraph H into file as a list of hyperedges\n\nArguments\n\nfile::String: full file name (including the path where you want to save it)\nH::Array{Array{Int64,1},1}: hypergraph\n\nSee also: assembly_hypergraph_GLV\n\n\n\n\n\n","category":"method"},{"location":"#CoexistHypergraph.jl-Documentation","page":"Home","title":"CoexistHypergraph.jl Documentation","text":"","category":"section"},{"location":"#Installation","page":"Home","title":"Installation","text":"","category":"section"},{"location":"#Julia","page":"Home","title":"Julia","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"This package is not registered (yet). You can install it via the Julia REPL like this:","category":"page"},{"location":"","page":"Home","title":"Home","text":"julia> using Pkg\njulia> Pkg.add(PackageSpec(url=\"https://github.com/akel123/CoexistHypergraph.jl.git\", rev=\"master\"))","category":"page"},{"location":"","page":"Home","title":"Home","text":"Or you can install it via the Pkg REPL like this:","category":"page"},{"location":"","page":"Home","title":"Home","text":"(v1.3) pkg> add https://github.com/akel123/CoexistHypergraph.jl.git#master","category":"page"},{"location":"#R","page":"Home","title":"R","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"If you already have R installed then you'll need to download install julia. You can check if julia is installed correctly by running the julia command in a terminal. If this command is not found, you will need to add it to your path following the proper instructions for your operating system.","category":"page"},{"location":"","page":"Home","title":"Home","text":"In R use JuliaCall is used to interface between languages. For function summaries see this document. However studying these functions is not necessary since CoexistHypergraph's shows the proper functions to use from JuliaCall in the tutorial and examples.","category":"page"},{"location":"","page":"Home","title":"Home","text":"The follwoing are steps to use CoexistHypergraph in R:","category":"page"},{"location":"","page":"Home","title":"Home","text":"install.packages(\"JuliaCall\")\n\nlibrary(JuliaCall)\njulia <- julia_setup()\n\n# only need to run this once\njulia_install_package(\"https://github.com/akel123/CoexistHypergraph.jl.git#master\")\n\n# add the library every time you open a new session of R and want to use CoexistHypergraph\njulia_library(\"CoexistHypergraph\")","category":"page"},{"location":"#Overview","page":"Home","title":"Overview","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Description","category":"page"},{"location":"","page":"Home","title":"Home","text":"(Image: )","category":"page"},{"location":"","page":"Home","title":"Home","text":"(Image: )","category":"page"},{"location":"#Quick-Example","page":"Home","title":"Quick Example","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"using CoexistHypergraph\n\nN = 8 # number of species in our ecosystem\n\n# create a random community matrix\nσA = 0.1 # standard devation for entries\nC = 0.1 # success rate of Bernoulli distribution used to populate matrix\nA = random_communitymatrix(N, σA, C)\n\n# create a random growth vector\nμ = 0.3 # mean of LogNormal distribution used to generate each value\nσr = 0.2 # standard deviation of LogNormal distribution used to generate each value\nr = random_r_vector(N, μ, σr)\n\n\nreg = 0\nmax_dim  = 4\nH = assembly_hypergraph_GLV(A, r; method = \"permanence\", regularization = reg)\nR = disassembly_hypergraph(H)\n\n# maybe save these for later if you want\nsave_hypergraph_dat(\"~/hypergraphs/assembly_hypergraph.dat\", H)\nsave_hypergraph_dat(\"~/hypergraphs/disassembly_hypergraph.dat\", R)\n\n# get the betti numbers\nbetti_H = betti_hypergraph_ripscomplex(H; max_dim = max_dim)","category":"page"},{"location":"#Citing","page":"Home","title":"Citing","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"If you use CoexistHypergraph for academic research, please cite the following paper.","category":"page"},{"location":"","page":"Home","title":"Home","text":"Paper Citation","category":"page"},{"location":"#Developers","page":"Home","title":"Developers","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Marco Tulio\nAaron Kelley","category":"page"},{"location":"tutorial/#Tutorial","page":"Tutorial","title":"Tutorial","text":"","category":"section"}]
}
