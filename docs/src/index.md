# CoexistHypergraph.jl Documentation

## Installation

### Julia
This package is not registered (yet).
You can install it via the Julia REPL like this:
```julia
julia> using Pkg
julia> Pkg.add(PackageSpec(url="https://github.com/akel123/CoexistHypergraph.jl.git", rev="master"))
```

Or you can install it via the Pkg REPL like this:
```julia
(v1.3) pkg> add https://github.com/akel123/CoexistHypergraph.jl.git#master
```
### R
```
Instructions for how to use it in R
```

## Overview
Description

![](./assets/species_to_graph.png)

![](./assets/graph_to_backbone.png)

## Quick Example

```julia
using CoexistHypergraph

N = 8 # number of species in our ecosystem

# create a random community matrix
σA = 0.1 # standard devation for entries
C = 0.1 # success rate of Bernoulli distribution used to populate matrix
A = random_communitymatrix(N, σA, C)

# create a random growth vector
μ = 0.3 # mean of LogNormal distribution used to generate each value
σr = 0.2 # standard deviation of LogNormal distribution used to generate each value
r = random_r_vector(N, μ, σr)


reg = 0
max_dim  = 4
H = assembly_hypergraph_GLV(A, r; method = "permanence", regularization = reg)
R = disassembly_hypergraph(H)

# maybe save these for later if you want
save_hypergraph_dat("~/hypergraphs/assembly_hypergraph.dat", H)
save_hypergraph_dat("~/hypergraphs/disassembly_hypergraph.dat", R)

# get the betti numbers
betti_H = betti_hypergraph_ripscomplex(H; max_dim = max_dim)
```

## Citing
If you use CoexistHypergraph for academic research, please cite the following paper.

Paper Citation

## Developers
-  Marco Tulio
- Aaron Kelley
