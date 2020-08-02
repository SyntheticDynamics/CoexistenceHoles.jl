
function hypergraph_density(H, number_of_species)
    temp = [count(h -> length(h) == i, H)/binomial(number_of_species, i) for i=1:number_of_species]

    return temp
end

function hypergraph_dimension(H)
    return maximum(length.(H))
end



function read_hypergraph(filename)
    Hp = readlines(filename)
    temp = [ vcat([parse(Int, ss) for ss in split.(h, ",")]...) for h in Hp]
    return temp
end


function get_descendents(G, h)
    return [union(h,v) for v in neighbors(G, last(h))]
end


function hypergraph_subdivide(H; expansion = false)

    # Build graph of inclusion between hyperedges.
    # convention is [i,j] for (i -> j)
    G = []
    @inbounds for size = reverse(2:hypergraph_dimension(H))
            nodes_s = findall(h -> length(h) == size , H) # v ∈ V such that length(H[v]) == size
            nodes_sm1 = findall(h -> length(h) < size, H) # v ∈ V such that length(H[v]) < size

            @inbounds for p in nodes_s, c in nodes_sm1
                    if H[c] ⊆ H[p]
                            push!(G, [p,c])
                    end
            end
    end



    if expansion .== false # return just G
            return G
    else # expand G to the Vietoris-Rips comples

            # Expand G into K_H
            roots = setdiff(1:length(H), last.(G)) # roots of G, all nodes without incoming edges (characterized by last item of pairs [i,j])
            tops = setdiff(1:length(H), first.(G)) # tops of G, all nodes without outgoing edges

            list = [[i] for i=1:length(H)] #initialize list of hyperedges
            let temp = [[h] for h in roots]
                    @inbounds @showprogress "Subdividing: " for i =1:hypergraph_dimension(H)-1
                            #temp = [union(h, v) for h in temp for v in neighbors(G, last(h)) ]
                            temp = vcat(map(h -> get_descendents(G, h), temp)...)
                            union!(list, temp)
                            # remove all nodes that are already at the top of G
                            temp = filter(x -> .!issubset(last(x), tops), temp)
                    end
            end
            return list
    end
end

"""
Computes Betti numbers of hypergraph.
Based on computing the hypergraph subdivision without expansion, which returns the inclusion graph
"""
function betti_hypergraph_ripscomplex(H; max_dim = 3)

    if length(H) == 0
        return zeros(max_dim + 1)
    else

        G = hypergraph_subdivide(H; expansion = false)
        # build distance matrix to give as input to Ripser.
        M = 2.0*ones(length(H), length(H))
        [ M[g[1], g[2]] = 1 for g in G ]

        #call Ripser
        barcodes = ripser(M; dim_max = max_dim, threshold = 1.5)
        # interpret the outout. Barcodes is an array of tuples of dim = max_dim + 1.
        # All tuples where the second entry is Inf are the persistent ones.
        # Betti numbers just count the number of those persistent ones.
        betti = [ count(x -> x[2] .== Inf, barcodes[i]) for i in 1:length(barcodes)]

        return betti
    end
end

"""
Computes the minimal simplicial complex containig the hypergraph H
"""
function minimal_simplicial_complex(hypergraph)
    K = Array{Int64, 1}[]
    #K = []
    for h in hypergraph
        union!(K, collect(combinations(h)))
    end
    return unique(Set, K) # delete duplicated simplices
end

"""
Computes missing edges of hypergraph H
"""
function missing_edges(hypergraph)
    return setdiff(minimal_simplicial_complex(hypergraph), hypergraph)
end

function disassembly_hypergraph(hypergraph)
    M = missing_edges(hypergraph)
    temp = filter(h -> length(h) == 1, hypergraph) # hyperedges of dimension = 1 (i.e., vertices)

    return union(temp, M)
end
