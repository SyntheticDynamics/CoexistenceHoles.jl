# CoexistHypergraph

<table width=100%>
<tr>
<td> Julia </td> <td> R </td>
</tr>
<tr>
<td>

```julia
using CoexistHypergraph






N = 8 # number of species in our ecosystem

# create a random community matrix
σA = 0.1 # standard deviation for entries
C = 0.1 # success rate of Bernoulli distribution used to populate matrix
A = random_communitymatrix(N, σA, C)

# create a random growth vector
μ = 0.3 # mean of LogNormal distribution used to generate each value
σr = 0.2 # standard deviation of LogNormal distribution used to generate each value
r = random_r_vector(N, μ, σr)

# create assembly and disassembly hypergraph
reg = 0
H = assembly_hypergraph_GLV(A, r; method = "permanence", regularization = reg)
R = disassembly_hypergraph(H)

# save these for later if you want
save_hypergraph_dat("~/hypergraphs/assembly_hypergraph.dat", H)
save_hypergraph_dat("~/hypergraphs/disassembly_hypergraph.dat", R)

# get the betti numbers
betti_H = betti_hypergraph_ripscomplex(H; max_dim = max_dim)
```

 </td>
<td>

```R
julia_library("CoexistHypergraph")

opt <- julia_pkg_import("CoexistHypergraph", func_list = c("random_communitymatrix",
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
H = opt$assembly_hypergraph_GLV(A,R; method="permanence", regularization=reg)
M = opt$disassembly_hypergraph(H)

# save these for later if you want
save_hypergraph_dat("~/hypergraphs/assembly_hypergraph.dat", H)
save_hypergraph_dat("~/hypergraphs/disassembly_hypergraph.dat", R)

# get the betti numbers
betti_H = betti_hypergraph_ripscomplex(H; max_dim = max_dim)

```

</td>
</tr>
</table>
