using Documenter, CoexistHypergraph

push!(LOAD_PATH,"../src/")

makedocs(
    sitename="CoexistHypergraph.jl",
    modules = [CoexistHypergraph],
    pages = Any[
        "home" => "index.md"
    ]
)
