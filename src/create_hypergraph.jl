
"""
is_GLVlocallystable(A, r)

Computes if the pair (A,r) has a feasible interior equilibrium that is stable.

# Arguments
- `A::Array{Real,2}`: community matrix
- `r::Array{Real, 1}`: growth vector

# Outputs
- `stability::Bool`: true = stable, false = not stable
"""
function is_GLVlocallystable(A::Array{<:Real,2}, r::Array{<:Real,1})::Bool
    N = size(A, 1)

    # compute interior equilibrium for the local community
    xss = -pinv(A)*r # r[1,:] instead of r, necessary when r is an Array{Float64, 2}

    # Check if equilibrium is stable.
    # First, check if xss < 0 (i.e., it unfeasible)
    if (minimum(xss) < 0)
              coexist = false
    else # it is feasible
              # check for stability
              M = diagm(xss)*A #community matrix
              λmax = maximum(real(eigvals(M)))

              coexist = λmax < 0 ? true : false

    end
    return coexist
end

"""
is_GLVpermanent(A, r; <keyword arguments>)

Computes permanence of the pair (A,r) using Jansen's criterion of mutual invasibility.
is_permanente(A,r;) -> Boolean

# Arguments
- `A::Array{<:Real,2}`: community matrix
- `r::Array{<:Real, 1}`: growth vector
- `regularization::Real=0`:
- `z_tolerance::Real=-1e-60`:
- `iterations::Integer=1e4`:

# Outputs
- `permanence::Bool`: true = permanent, false = not permanent
"""
function is_GLVpermanent(A::Array{<:Real, 2}, r::Array{<:Real, 1}; regularization::Real = 0, z_tolerance::Real = -1e-60, iterations::Int = Int(1e4))::Bool
    N = size(A, 1)

    # Regularize A by adding a small negative diagonal term
    regularization > 0 ? Atemp = A .+ Diagonal(Distributions.rand(Uniform(-1.0*regularization, 0), N)) : Atemp = copy(A)

    if N == 1 # just scalar equation
        coexistence = Atemp[1] < 0 && r[1] > 0 ?  true : false
    else # N > 1

        # check if it has an interior feasible equilibria
        if rank(Atemp) .== rank([Atemp r]) # if solution exists

            xeqint = -pinv(Atemp)*r

            if minimum(xeqint) > 0 # if interior is feasible

                equilibria = []
                @inbounds for localcommunityID = 1: 2^N-1

                #@inbounds @showprogress for localcommunityID = 1: 2^N-1

                    # calculate present species for that local communtiy
                    z = digits(localcommunityID, base = 2, pad = N) # integer to binary
                    indx = findall( z .== 1)

                    # build local (Alocal, rlocal) with only the present species
                    Alocal = Atemp[indx,indx]
                    rlocal = r[indx]

                    # Check if there exists a solution to Alocal*x + rlocal
                    if rank(Alocal) .== rank([Alocal rlocal]) # solution exists
                        #@show localcommunityID
                        xss = -pinv(Alocal)*rlocal

                        if (minimum(xss) > 0) # if solution is feasible
                            #@show localcommunityID
                            xtemp = zeros(N)
                            xtemp[indx] = xss
                            push!(equilibria, xtemp)
                            #equilibria = hcat(equilibria, convert(Array{Float64,2}, xtemp))
                        else
                        end

                    else # solution does not exists

                    end

                end
                Xss = hcat(equilibria...)


                if size(Xss, 2) >= 1 # at least one boundary equilibrium
                    # Test for Jansen's criterion of permanence
                    h = Variable(N)
                    z = z_tolerance

                    M = Atemp*Xss
                    v = ones(1, size(Xss,2))
                    #problem = minimize(1, [h'*M + (h'*r)*v + z*v >= 0, h >= 1e-60, sum(h) == 1])
                    problem = minimize(1, [h'*M + (h'*r)*v + z*v >= 0, h >= 1e-60, sum(h) == 1])
                    # Solve the problem by calling solve!
                    #Convex.solve!(problem, SCSSolver(max_iters = iterations, verbose=false))
                    # Convex.solve!(problem, () -> SCS.Optimizer(verbose = false, max_iters = iterations), verbose=false)
                    solve!(problem, () -> Optimizer(verbose = false, max_iters = iterations), verbose=false)

                    # Check if problem.status = "OPTIMAL::TerminationStatusCode = 1"
                    Integer(problem.status) .== 1 ? coexistence = true : coexistence = false
                else # no boundary equilibrium, true by default
                    coexistence = true
                end

            else # interior is not feasible
                coexistence = false
            end


        else # if there is no interior equilibrium
            coexistence = false
        end
    end

    return coexistence
end

"""

assembly_hypergraph_GLV(A,r; <keyword arguments>)
Computes the assembly hypergraph for (A,r).

# Arguments
- `A::Array{<:Real,2}`: community matrix
- `r::Array{<:Real, 1}`: growth vector
- `method::String="permanence"`: will return a randomized growthvector using one of the following methods
    - `"permanence"`: uses the is_GLVpermantent(@ref) to determine interspecies coexistance
    - `"localstability"`: uses the is_GLVlocallystable(@ref) to determine interspecies coexistance
- `regularization::Real=0`:

# Outputs
- `hypergraph::Array{Array{Int64,1},1}`: array of hyper edges: species in edge => species coexist
"""
function assembly_hypergraph_GLV(A::Array{<:Real,2}, r::Array{<:Real,1}; method::String = "permanence", regularization::Real = 0)::Array{Array{Int64,1},1}
    N = size(A, 1)

    hyperdges = Array{Int64, 1}[]
    #hyperdges = []

    if method .== "permanence"
        print("\nCalculating coexistence hypergraph (method: permanence) \n")
        @inbounds for community_id = 1 : 2^N-1
        #@inbounds @showprogress 0.0001 for community_id = 1 : 2^N-1
            z = digits(community_id, base = 2, pad = N) # integer to binary
            indx = findall( z .== 1)

            if is_GLVpermanent(A[indx, indx], r[indx]; regularization = regularization) .== true
                push!(hyperdges, indx)
            end
        end

    elseif method .== "localstability"
        print("\nCalculating coexistence hypergraph (method: local stability) \n")
        @inbounds @showprogress 0.0001 for community_id = 1 : 2^N-1
            z = digits(community_id, base = 2, pad = N) # integer to binary
            indx = findall( z .== 1)

            if is_GLVlocallystable(A[indx, indx], r[indx]) .== true
                push!(hyperdges, indx)
            end
        end
    end
    return hyperdges

end

"""
save_hypergraph_dat(file, H)

Saves the hypergraph H into file as a list of hyperedges

# Arguments
- `file::String`: full file name (including the path where you want to save it)
- `H::Array{Array{Int64,1},1}`: hypergraph

See also: [`assembly_hypergraph_GLV`](@ref)
"""
function save_hypergraph_dat(file::String, H::Array{Array{Int64,1},1})::Nothing
    out = [filter(x -> !isspace(x), chop(repr(h), head = 1, tail =1))*"\n" for h in H] |> join
    write(file, out)
end

"""
random_growthvector(N, μ, σ; seed=nothing)

Generates a random growth vector (the "r" vector in the generalized
[Lotka-Voltera](https://en.wikipedia.org/wiki/Generalized_Lotka%E2%80%93Volterra_equation)  equation)

# Arguments
- `N::Real`: length of returned growth vector
- `μ::Real`: mean of LogNormal distribution used to generate each value
- `σ::Real`: standard deviation of LogNormal distribution used to generate each value
- `seed::Union{Nothing, <:Int}=nothing`: if specified, this seed will be used in the random number generator, allowing reproducibility

# Output
- `growth_vector::Array{<:Real,1}`
See also: [`randomize_growthvector`](@ref)
"""
function random_growthvector(N, μ, σ; seed=nothing)::Array{<:Real,1}
    @show 'hi'
    if seed != nothing; seed!(seed); end
    Distributions.rand(LogNormal(μ, σ), N)
end

"""
randomize_growthvector(r; <keyword arguments>)

# Arguments
- `r::Array{<:Real,1}`: growth vector (this can be generated randomly by [`random_growthvector`](@ref))
- `method::String="preserve_norm"`: will return a randomized growthvector using one of the following methods
    - `"preserve_norm"`: generated using a normal distribution for each entry, and then scaled to have the same norm as growth vector input (r)
    - `"shuffle"`: randomly permute growth vector input (r)
    - `"sample"`: randomly sample (with replacement) entries of growth vector input (r)
    - `"preserve_sign_shuffle"`: same as "shuffle" but the signs are not modified
    - `"preserve_sign_sample"`: same as "sample" but the signs are not modified
- `seed::Union{Nothing, <:Int}=nothing`: if specified, this seed will be used in the random number generator, allowing reproducibility

# Output
- `growth_vector::Array{<:Real,1}`

See also: [`random_growthvector`](@ref)
"""
function randomize_growthvector(r::Array{<:Real,1}; method::String="preserve_norm", seed::Union{Nothing, <:Int}=nothing)::Array{<:Real,1}
    if seed != nothing; seed!(seed); end # set seed

    if  method == "preserve_norm"               # new random growth vector but same norm as r
        v = Distributions.rand(Normal(), length(r))
        return norm(r,2).*v/norm(v,2)
    elseif method == "preserve_sign_sample"     # unifmormly sampled from values of r, preserve signs
        values = abs.(r)
        return sign.(r).*sample(values, length(r))
    elseif method == "preserve_sign_shuffle"    # randomly permuted from values of r, preserve signs
        values = abs.(r)
        return sign.(r).*shuffle(values)
    elseif method == "shuffle"                  # randomly permuted from values of r
        return shuffle(r)
    elseif method == "sample"                   # unifmormly sampled from values of r
        return sample(r, length(r))
    end

    @warn "Method Not Recognized: returning original growth vector"
    return r
end


"""
random_communitymatrix(N, σ, p)

Generates a random community matrix (the "A" matrix in the generalized
[Lotka-Voltera](https://en.wikipedia.org/wiki/Generalized_Lotka%E2%80%93Volterra_equation) equation).
entries according to a Bernoulli distribution with success rate parameter, p (the
entries that are not "populated" are set to 0)


# Arguments
- `N::Real`: dimension of returned square matrix (N x N)
- `σ::Real`: standard deviation of normal distribution used to generate each entry (μ = 0)
- `p::Real`: success rate of Bernoulli distribution used to populate the returned matrix
- `seed::Union{Nothing, <:Int}=nothing`: if specified, this seed will be used in the random number generator, allowing reproducibility

# Output
- `community_matrix::Array{<:Real,2}`

See also: [`randomize_communitymatrix`](@ref)
"""
function random_communitymatrix(N::Real, σ::Real, p::Real; seed::Union{Nothing, <:Int}=nothing)::Array{<:Real,2}
    if seed != nothing; seed!(seed); end # set seed
    W = Distributions.rand(Normal(0, σ), N, N)
    Z = Distributions.rand(Bernoulli(p), N, N)
    temp = W.*Z
    temp[diagind(temp)] .= -1

    return temp
end

"""
randomize_communitymatrix(A; <keyword arguments>)


# Arguments
- `r::Array{<:Real,2}`: growth vector (this can be generated randomly by [`random_growthvector`](@ref))
- `method::String="shuffle"`: will return a randomized community matrix using one of the following methods
    - `"shuffle"`: shuffles all of the entries except for the ones on the diagonals
    - `"preserve_sign_shuffle"`: same as "shuffle" but the signs are not modified
- `seed::Union{Nothing, <:Int}=nothing`: if specified, this seed will be used in the random number generator, allowing reproducibility

# Output
- `community_matrix::Array{<:Real,2}`

See also: [`random_communitymatrix`](@ref)

"""
function randomize_communitymatrix(A::Array{<:Real,2}; method::String="shuffle", seed::Union{Nothing, <:Int}=nothing)::Array{<:Real,2}
    if seed != nothing; seed!(seed); end # set seed
    Atemp = deepcopy(A)
    if method == "shuffle"
        # list tuples (i,j) excepting  if i == j
        tuples_orig = [(i,j) for i = 1:size(A, 1) for j = setdiff(1:size(A, 2), i)]
        # shuffel tuples
        tuples_shuff = shuffle(tuples_orig)
        # randomize matrix using shuffled tuples
        Atemp[CartesianIndex.(tuples_orig)] = Atemp[CartesianIndex.(tuples_shuff)]
        return Atemp
    elseif method == "sample"
        # list tuples (i,j) excepting  if i == j
        tuples_orig = [(i,j) for i = 1:size(A, 1) for j = setdiff(1:size(A, 2), i)]
        # shuffel tuples
        tuples_shuff = sample(tuples_orig, length(tuples_orig))
        # randomize matrix using shuffled tuples
        Atemp[CartesianIndex.(tuples_orig)] = Atemp[CartesianIndex.(tuples_shuff)]
        return Atemp
    elseif method == "preserve_sign_shuffle"
        diagonal = shuffle(abs.(diag(Atemp))) # shuffle diags
        Atemp2 = deepcopy(Atemp)
        Atemp2[diagind(Atemp2)] .= 0
        non_diag_non_zero = shuffle(abs.(Atemp2[ Atemp2 .!= 0])) # strength of non-diagonal and non-zero entries
        d_count = 1;
        n_count = 1;
        Ar = zeros(size(Atemp))
        for i = 1: size(Atemp, 1), j = 1: size(Atemp, 2)
            if i == j
                Ar[i,j] = diagonal[d_count]*sign(Atemp[i,j])
                d_count+=1;
            else
                Ar[i,j] = non_diag_non_zero[n_count]*sign(Atemp[i,j])
                n_count+=1*(Atemp[i,j]!=0)
            end
        end

        return Ar
    elseif method == "preserve_sign_sample"
        diagonal = abs.(diag(Atemp)) # stength diagonal entries
        Atemp2 = deepcopy(Atemp)
        Atemp2[diagind(Atemp2)] .= 0
        non_diag_non_zero = abs.(Atemp2[ Atemp2 .!= 0]) # strength of non-diagonal and non-zero entries

        Ar = zeros(size(Atemp))
        for i = 1: size(Atemp, 1), j = 1: size(Atemp, 2)
            if i == j
                Ar[i,j] = sample(diagonal)*sign(Atemp[i,j])
            else
                Ar[i,j] = sample(non_diag_non_zero)*sign(Atemp[i,j])
            end
        end

        return Ar
    end
    @warn "Method Not Recognized: returning original growth community matrix"
    return A
end
