# Using R language


There are quite a few ways to use `CoexistenceHoles` in `R` using `JuliaCall`. Here are 3 examples that achieve the same result.

#### 1) evals and calls
This is the quick and dirty way of running julia code in R. We do not recommend it as a very effective way to write a project, but it exists.
```R
A = julia_eval("random_communitymatrix(8, 0.1, 0.1)")
r = julia_eval("random_growthvector(8, 0.1, 0.1)")
H  = julia_call("assembly_hypergraph_GLV", A, r)
```

#### 2) julia_function()
This is a much cleaner way if you want to integrate a few functions from `CoexistenceHoles` into your R code.
```R
# define you functions from julia in R
random_growthvector = julia_function("random_growthvector", pkg_name="CoexistenceHoles")
random_communitymatrix = julia_function("random_communitymatrix", pkg_name="CoexistenceHoles")
assembly_hypergraph_GLV = julia_function("assembly_hypergraph_GLV", pkg_name="CoexistenceHoles")

# use them directly
A = random_communitymatrix(8, 0.1, 0.1)
r = random_growthvector(8, 0.1, 0.1)
H = assembly_hypergraph_GLV(A, r)
```

#### 3) julia_pkg_import()
You also have the choice to import multiple functions at once. This can be usefull if you are using many functions from `CoexistenceHoles`
```R
# import the functions from the package and store them in opt
opt <- julia_pkg_import("CoexistenceHoles", func_list = c("random_communitymatrix",
                                                           "random_growthvector",
                                                           "assembly_hypergraph_GLV"))

# access the functions through opt variable
A = opt$random_communitymatrix(8, 0.1, 0.1)
r = opt$random_growthvector(8, 0.1, 0.1)
H = opt$assembly_hypergraph_GLV(A,R)
```
