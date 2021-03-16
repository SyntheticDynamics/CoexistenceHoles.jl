# CoexistenceHoles.jl Documentation

## Quick Overview
CoexistenceHoles is a [`julia`](https://julialang.org/) and [`R`](https://www.r-project.org/) package that originally was made for the project "Coexistence holes characterize the assembly and disassembly of multispecies sytems". However, the package has the potential for a variety of applications. In short, it provides efficient tools for analyzing the homology of general hypergraphs.

## Installation

#### Julia
This package is not registered (yet).
You can install it via the Julia REPL like this:
```julia
julia> using Pkg
julia> Pkg.add(PackageSpec(url="https://github.com/SyntheticDynamics/CoexistenceHoles.jl.git", rev="master"))
```

Or you can install it via the Pkg REPL like this:
```julia
(v1.3) pkg> add https://github.com/SyntheticDynamics/CoexistenceHoles.jl.git#master
```
#### R
This package can also be used with [`R`](https://www.r-project.org/). With `R` installed, you'll still need to download install [`julia`](https://julialang.org/), although you won't be using it directly. You can check if julia is installed correctly by running the `julia` command in a terminal. If this command
is not found, you will need to add it to your path following the proper [instructions](https://julialang.org/downloads/platform/) for your operating system.

In `R` we use [`JuliaCall`](https://github.com/Non-Contradiction/JuliaCall) as an interface to access the `julia` code. There are many ways to access the package with `R`. [Here](./R_use.md) are someuseful ones, or just keep reading to get started right away. For more in-depth function summaries take a look at the official [documentation](https://cran.r-project.org/web/packages/JuliaCall/JuliaCall.pdf).

The follwoing are steps to install `CoexistenceHoles` in `R`. See the [examples](./examples.md)
or [tutorials](./tutorial.md) for more specific instructions.
```R
install.packages("JuliaCall")

library(JuliaCall)
julia <- julia_setup()

# only need to run this once
julia_install_package("https://github.com/SyntheticDynamics/CoexistenceHoles.jl.git#master")

# add the library every time you open a new session of R and want to use CoexistenceHoles
julia_library("CoexistenceHoles")
```




## Quick Example
#### Julia
```julia
using CoexistenceHoles

N = 8 # number of species in our ecosystem

# create a random community matrix
σA = 0.1 # standard devation for entries
C = 0.1 # success rate of Bernoulli distribution used to populate matrix
A = random_communitymatrix(N, σA, C)

# create a random growth vector
μ = 0.3 # mean of LogNormal distribution used to generate each value
σr = 0.2 # standard deviation of LogNormal distribution used to generate each value
r = random_growthvector(N, μ, σr)


reg = 0
max_dim  = 4
H = assembly_hypergraph_GLV(A, r; method = "localstability", regularization = reg)
R = disassembly_hypergraph(H)

# maybe save these for later if you want
save_hypergraph_dat("~/hypergraphs/assembly_hypergraph.dat", H)
save_hypergraph_dat("~/hypergraphs/disassembly_hypergraph.dat", R)

# get the betti numbers
betti_H = betti_hypergraph_ripscomplex(H; max_dim = max_dim)
```

#### R

```R
julia_library("CoexistenceHoles")

opt <- julia_pkg_import("CoexistenceHoles", func_list = c("random_communitymatrix",
                                                           "random_growthvector",
                                                           "assembly_hypergraph_GLV",
                                                           "dissassembly_hypergraph",
                                                           "save_hypergraph_dat"))
N = 8 # number of species in our ecosystem

# create a random community matrix
sA = 0.1 # standard deviation for community matrix
C = 0.1 # success rate of Bernoulli distribution used to populate matrix
A = opt$random_communitymatrix(N, sA, C)

# create a random growth vector
mr = 0.1
sr = 0.1
r = opt$random_growthvector(N, mr, sr)

# create assembly and disassembly hypergraph
reg = 0
H = opt$assembly_hypergraph_GLV(A,R; method="localstability", regularization=reg)
M = opt$disassembly_hypergraph(H)

# save these for later if you want
save_hypergraph_dat("~/hypergraphs/assembly_hypergraph.dat", H)
save_hypergraph_dat("~/hypergraphs/disassembly_hypergraph.dat", R)

# get the betti numbers
betti_H = betti_hypergraph_ripscomplex(H; max_dim = 4)
```

## Citing
If you use CoexistenceHoles for academic research, please cite the following paper.

Paper Citation

## Developers
-  Marco Tulio
- Aaron Kelley
