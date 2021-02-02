using Documenter, CoexistHypergraph

push!(LOAD_PATH,"../src/")

makedocs(
    sitename="CoexistHypergraph.jl",
    modules = [CoexistHypergraph],
    pages = Any[
        "Home" => "index.md"
        "Overview" => "overview.md"
        "User Guide" => [
            "examples.md",
            "tutorial.md",
            "glossary.md",
            "R_use.md"
            ]
    ]
)

deploydocs(
    repo = "github.com/akel123/CoexistHypergraph.jl.git"
)
