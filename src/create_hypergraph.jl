
"""
Computes if the pair (A,r) has a feasible interior equilibrium that is stable.
"""
function is_GLVlocallystable(A, r)
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
Computes permanence of the pair (A,r) using Jansen's criterion of mutual invasibility.
is_permanente(A,r;) -> Boolean
"""
function is_GLVpermanent(A, r; regularization = 0, z_tolerance = -1e-60, iterations = 1e4)
    N = size(A, 1)

    # Regularize A by adding a small negative diagonal term
    regularization > 0 ? Atemp = A .+ Diagonal(rand(Uniform(-1.0*regularization, 0), N)) : Atemp = copy(A)

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
Computes the coexistence hypergraph for (A,r).
Methods: "permanence", "localstability"
"""
function assembly_hypergraph_GLV(A, r; method = "permanence", regularization = 0)
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
Saves the hypergraph H into file as a list of hyperedges
"""
function save_hypergraph_dat(file, H)
    out = [filter(x -> !isspace(x), chop(repr(h), head = 1, tail =1))*"\n" for h in H] |> join
    write(file, out)
end

"""
randomize community matrix
"""
function randomize_communitymatrix(A)
    Atemp = deepcopy(A)

    # list tuples (i,j) excepting  if i == j
    tuples_orig = [(i,j) for i = 1:size(A, 1) for j = setdiff(1:size(A, 2), i)]
    # shuffel tuples
    tuples_shuff = shuffle(tuples_orig)

    # randomize matrix using shuffled tuples
    Atemp[CartesianIndex.(tuples_orig)] = Atemp[CartesianIndex.(tuples_shuff)]

    return Atemp
end

function randomize_communitymatrix_signpreserving(Atemp)
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


function randomize_growthvector_signpreserving(r)
    values = abs.(r)
    return sign.(r').*sample(values, length(r))
end


function randomize_growthvector(r)
    return sample(values, length(r))
end


function random_growthvector(r)
    v = rand(Normal(), length(r))
    return norm(r,2).*v/norm(v,2)
end

"""
random_communitymatrix(N, σ, C)

Generate a random community matrix (the "A" matrix in the generalized
Lotka-Voltera equation).

...
# Arguments
`σ::Number : `
...
"""
function random_communitymatrix(N, σ, C)
    W = rand(Normal(0, σ), N, N)
    Z = rand(Bernoulli(C), N, N)
    temp = W.*Z
    temp[diagind(temp)] .= -1

    return temp
end

function random_r_vector(N, μ, σ)
    rand(LogNormal(μ, σ), N)
end
