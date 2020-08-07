using Documenter, CoexistHypergraph

push!(LOAD_PATH,"../src/")

makedocs(
    sitename="CoexistHypergraph.jl",
    modules = [CoexistHypergraph],
    pages = Any[
        "Home" => "index.md"
        "User Guide" => [
            "examples.md",
            "tutorial.md",
            "glossary.md"
            ]
    ]
)
