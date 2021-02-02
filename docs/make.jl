using Documenter, CoexistenceHoles

push!(LOAD_PATH,"../src/")

makedocs(
    sitename="CoexistenceHoles.jl",
    # modules = [CoexistenceHoles],
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
    doctest=fasle,
)

deploydocs(
    repo = "github.com/mtangulo/CoexistenceHoles.jl.git"
)
