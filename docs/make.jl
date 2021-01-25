using Documenter
using Coordinates

makedocs(;
    format = Documenter.HTML(prettyurls = get(ENV, "CI", nothing) == "true"),
    modules = [Coordinates],
    sitename = "Coordinates.jl",
    pages=[
        "Home" => "index.md",
    ],
    doctest = true, # :fix
)

deploydocs(
    repo = "github.com/KeitaNakamura/Coordinates.jl.git",
    devbranch = "main",
)
