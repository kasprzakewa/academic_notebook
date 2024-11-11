# Ewa Kasprzak 272356

struct Graph
    directed::Bool
    vertices::Int
    edges::Vector{Tuple{Int, Int}}
    adjacency_list::Vector{Vector{Int}}
end

function read_graph(filename::String)
    open(filename, "r") do file
        flag = readline(file)
        directed = flag == "D"
        n = parse(Int, readline(file))
        m = parse(Int, readline(file))

        edges = Vector{Tuple{Int, Int}}()
        adjacency_list = [Int[] for _ in 1:n]

        for _ in 1:m
            line = readline(file)
            u, v = split(line) |> x -> (parse(Int, x[1]), parse(Int, x[2]))
            push!(edges, (u, v))
            push!(adjacency_list[u], v)
            if !directed
                push!(adjacency_list[v], u)
            end
        end

        for i in 1:n
            sort!(adjacency_list[i])
        end
        
        return Graph(directed, n, edges, adjacency_list)
    end
end

function print_adjacency_list(graph::Graph)
    println("Lista sąsiedztwa:")
    for i in 1:graph.vertices
        println("Wierzchołek $i: ", graph.adjacency_list[i])
    end
end

function explore_iterative(graph::Graph, start::Int, visited::BitVector, previsit::Vector{Int}, postvisit::Vector{Int}, parent_children::Dict{Int, Vector{Int}}, parent::Int, stack::Vector{Int}, has_cycle::Ref{Bool})
    local_stack = [(start, parent)]

    while !isempty(local_stack)
        (v, parent) = pop!(local_stack)
        
        if !visited[v]
            visited[v] = true
            push!(previsit, v)

            if !haskey(parent_children, parent)
                parent_children[parent] = Int[]
            end
            push!(parent_children[parent], v)
            push!(local_stack, (v, -1)) 
            
            for u in graph.adjacency_list[v]
                if !visited[u]
                    push!(local_stack, (u, v))
                end
            end
        elseif parent == -1 
            push!(postvisit, v)
        end
    end
end


function dfs(graph::Graph)
    visited = falses(graph.vertices)
    previsit = Int[]
    postvisit = Int[]
    parent_children = Dict{Int, Vector{Int}}()
    stack = zeros(Int, graph.vertices) 
    has_cycle = Ref(false)  

    for v in 1:graph.vertices
        if !visited[v]
            explore_iterative(graph, v, visited, previsit, postvisit, parent_children, 0, stack, has_cycle)
        end
    end

    return previsit, postvisit, parent_children, has_cycle[]
end


function bfs(graph::Graph, start::Int)
    dist = fill(Inf, graph.vertices)
    dist[start] = 0
    queue = [start]
    visited = falses(graph.vertices)  
    visited[start] = true              

    previsit = Int[]                    
    postvisit = Int[]                   
    parent_children = Dict{Int, Vector{Int}}(0 => Int[]) 
    push!(parent_children[0], start)

    while !isempty(queue)
        u = popfirst!(queue)            
        push!(previsit, u)              

        for v in graph.adjacency_list[u]
            if !visited[v]              
                visited[v] = true       
                dist[v] = dist[u] + 1   

                if !haskey(parent_children, u)
                    parent_children[u] = Int[]
                end
                push!(parent_children[u], v)  

                push!(queue, v)         
            end
        end

        push!(postvisit, u)             
    end

    return dist, previsit, postvisit, parent_children  
end

function is_cyclic_helper(graph::Graph, u::Int, visited::BitVector, rec_stack::BitVector)
    visited[u] = true
    rec_stack[u] = true

    for v in graph.adjacency_list[u]
        if !visited[v] && is_cyclic_helper(graph, v, visited, rec_stack)
            return true
        elseif rec_stack[v]
            return true
        end
    end

    rec_stack[u] = false
    return false
end

function is_cyclic(graph::Graph)
    visited = falses(graph.vertices)
    rec_stack = falses(graph.vertices)

    for i in 1:graph.vertices
        if !visited[i]
            if is_cyclic_helper(graph, i, visited, rec_stack)
                return true
            end
        end
    end

    return false
end

function topological_sort(graph::Graph)
    if !graph.directed
        println("Sortowanie topologiczne jest zdefiniowane tylko dla grafów skierowanych.")
        return []
    end

    previsit, postvisit, parent_children = dfs(graph)
    
    if is_cyclic(graph)
        println("Graf zawiera cykl. Niemożliwe jest wykonanie sortowania topologicznego.")
        return []
    end

    return reverse(postvisit)
end

function reverse_graph(graph::Graph)
    reversed_edges = [(v, u) for (u, v) in graph.edges]
    reversed_adjacency_list = [Int[] for _ in 1:graph.vertices]

    for (u, v) in reversed_edges
        push!(reversed_adjacency_list[u], v)
    end

    return Graph(true, graph.vertices, reversed_edges, reversed_adjacency_list)
end

function scc(graph::Graph)
    if !graph.directed
        println("Silnie spójne składowe są zdefiniowane tylko dla grafów skierowanych.")
        return [], 0, []
    end

    reversed_graph = reverse_graph(graph)
    previsit, postvisit, parent_children, _ = dfs(reversed_graph)

    sccs = Vector{Vector{Int}}()
    visited = falses(graph.vertices)

    for v in postvisit
        if !visited[v]
            scc = Int[]
            explore_scc_iterative(reversed_graph, v, visited, scc)
            push!(sccs, scc)
        end
    end

    scc_sizes = [length(scc) for scc in sccs]
    return sccs, length(sccs), scc_sizes
end

function explore_scc_iterative(graph::Graph, start::Int, visited::BitVector, scc::Vector{Int})
    stack = [start]

    while !isempty(stack)
        v = pop!(stack)

        if !visited[v]
            visited[v] = true
            push!(scc, v)

            for u in graph.adjacency_list[v]
                if !visited[u]
                    push!(stack, u)
                end
            end
        end
    end
end

function is_bipartite(graph::Graph)
    colors = fill(-1, graph.vertices)
    set1 = Vector{Int}()
    set2 = Vector{Int}()

    for start in 1:graph.vertices
        if colors[start] == -1
            if !bfs_check(graph, start, colors, set1, set2)
                return false, Int[], Int[] 
            end
        end
    end

    return true, set1, set2 
end

function bfs_check(graph::Graph, start::Int, colors::Vector{Int}, set1::Vector{Int}, set2::Vector{Int})
    queue = [start]
    colors[start] = 0
    push!(set1, start)

    while !isempty(queue)
        v = popfirst!(queue)

        for u in graph.adjacency_list[v]
            if colors[u] == -1
                colors[u] = 1 - colors[v]
                if colors[u] == 0
                    push!(set1, u)
                else
                    push!(set2, u)
                end
                push!(queue, u)
            elseif colors[u] == colors[v]
                return false 
            end
        end
    end

    return true  
end

function print_tree(parent_children::Dict{Int, Vector{Int}}, parent::Int, indent::String)
    if haskey(parent_children, parent)
        children = parent_children[parent]
        for child in children
            if parent == 0
                println("--->" * string(child)) 
            else
                println(indent * "└── " * string(child)) 
            end
            print_tree(parent_children, child, indent * "    ")  
        end
    end
end


function main()
    if isempty(ARGS)
        println("Podaj nazwę pliku jako argument.")
        return
    end

    filename = ARGS[1]
    graph = read_graph(filename)

    previsit_dfs, postvisit_dfs, parent_children_dfs, has_cycle_dfs = dfs(graph)
    println("DFS:")
    println("-----------------------------------------------")
    if graph.vertices <= 200
        println("Indeksy previsit (DFS): ", previsit_dfs)
        println()
        println("Indeksy postvisit (DFS): ", postvisit_dfs)
        println()
        println("Drzewo przejścia (DFS):")
        print_tree(parent_children_dfs, 0, "")
    else 
        println("Zbyt dużo wierzchołków, aby wyświetlić wyniki.")
    end

    println()
    println("===============================================")
    println("BFS:")
    println("-----------------------------------------------")
    start_vertex = 1
    distances, previsit_bfs, postvisit_bfs, parent_children_bfs = bfs(graph, start_vertex)
    if graph.vertices <= 200
        println("Odległości od wierzchołka $start_vertex: ")
        for i in 1:graph.vertices
            println("Wierzchołek $i: ", distances[i])
        end
        println()
        println("Indeksy previsit (BFS): ", previsit_bfs)
        println()
        println("Indeksy postvisit (BFS): ", postvisit_bfs)
        println()
        println("Drzewo przejścia (BFS):")
        print_tree(parent_children_bfs, 0, "")
    else 
        println("Zbyt dużo wierzchołków, aby wyświetlić wyniki.")
    end

    println()
    println("===============================================")
    println("Sortowanie topologiczne:")
    println("-----------------------------------------------")
    topological_order = topological_sort(graph)
    if !isempty(topological_order)
        if graph.vertices <= 200
            println("Kolejność topologiczna: ", topological_order)
        else
            println("Zbyt dużo wierzchołków, aby wyświetlić wyniki.")
        end
    end

    println()
    println("===============================================")
    println("Silnie spójne składowe:")
    println("-----------------------------------------------")
    sccs, sccs_length, scc_sizes = scc(graph)
    if !isempty(sccs)
        println("Liczba silnie spójnych składowych: ", sccs_length)
        println("Rozmiary silnie spójnych składowych: ", scc_sizes)
        if graph.vertices <= 200
            for (i, scc) in enumerate(sccs)
                println("Silnie spójna składowa $i: ", scc)
            end
        end
    end

    println()
    println("===============================================")
    println("Dwudzielność:")
    println("-----------------------------------------------")
    is_bipartite_graph, set1, set2 = is_bipartite(graph)
    if is_bipartite_graph
        println("Graf jest dwudzielny.")

        if graph.vertices <= 200
            println("Zbiór 1: ", set1)
            println("Zbiór 2: ", set2)
        end
    else
        println("Graf nie jest dwudzielny.")
    end

end

main()
