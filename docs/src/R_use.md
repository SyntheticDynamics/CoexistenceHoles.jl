#CoexistHypergraph in R
#### Quick notes on how to use `CoexistHypergraph` with `JuliaCall`
There are quite a few ways to use `CoexistHypergraph` in `R`. Here are 3 examples that achieve the same result
```R
A = julia_eval("random_communitymatrix(8, 0.1, 0.1)")
r = julia_eval("random_growthvector(8, 0.1, 0.1)")
H  = julia_call("assembly_hypergraph_GLV", A, r)
```
```R
# define you functions from julia in R
random_growthvector = julia_function("random_growthvector", pkg_name="CoexistHypergraph")
random_communitymatrix = julia_function("random_communitymatrix", pkg_name="CoexistHypergraph")
assembly_hypergraph_GLV = julia_function("assembly_hypergraph_GLV", pkg_name="CoexistHypergraph")

# use them directly
A = random_communitymatrix(8, 0.1, 0.1)
r = random_growthvector(8, 0.1, 0.1)
H = assembly_hypergraph_GLV(A, r)
```
```
# import the functions from the package and store them in opt
opt <- julia_pkg_import("CoexistHypergraph", func_list = c("random_communitymatrix",
                                                           "random_growthvector",
                                                           "assembly_hypergraph_GLV"))

# access the functions through opt variable
A = opt$random_communitymatrix(8, 0.1, 0.1)
r = opt$random_growthvector(8, 0.1, 0.1)
H = opt$assembly_hypergraph_GLV(A,R)
```
