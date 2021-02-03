using Documenter
using CoexistenceHoles

push!(LOAD_PATH,"../src/")

makedocs(
    sitename="CoexistenceHoles.jl",
    modules = [CoexistenceHoles],
    pages = Any[
        "Home" => "index.md"
        "Overview" => "overview.md"
        "User Guide" => [
            "examples.md",
            "tutorial.md",
            "glossary.md",
            "R_use.md"
            ]
    ],
)

deploydocs(
    repo = "github.com/SyntheticDynamics/CoexistenceHoles.jl.git"
)
