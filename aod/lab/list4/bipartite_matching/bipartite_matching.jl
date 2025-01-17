module bipartite_matching

export Vertex, V_set, Graph_struct, add_edges, reconstruct_path, augment, find_biggest_matching, print_path

using StatsBase
using DataStructures

mutable struct Vertex
    value::Int64
    neighbours::Vector{Tuple{Vertex, Int64, Bool}}
    labeled::Bool
    Vertex(value) = new(value, Vector{Tuple{Vertex, Int64, Bool}}(), false)
end

mutable struct Graph_struct
    V1::Vector{Vertex}
    V2::Vector{Vertex}
    k::Int64

    Graph_struct(k) = new([Vertex(i) for i in 1:2^k], [Vertex(i) for i in (2^k + 1):2^(k+1)], k)
end

function add_edges(graph::Graph_struct, i::Int64)
    for v in graph.V1
        S = sample(graph.V2, i, replace = false)

        for w in S
            push!(v.neighbours, (w, 1, false))
            push!(w.neighbours, (v, 0, false))
            @assert w.value in (2^(graph.k) + 1):(2^((graph.k)+1))
        end
    end 
end

function reconstruct_path(pred::Dict{Vertex, Vertex}, start::Vertex, finish::Vertex)::Vector{Vertex}
    path = [finish]
    current = finish
    while current != start
        current = pred[current]
        pushfirst!(path, current)
    end
    return path
end

function augment_arc(v::Vertex, w::Vertex, capacity::Int64, add_edge::Bool)::Int64
    for i in 1:length(v.neighbours)
        if v.neighbours[i][1] == w
            v.neighbours[i] = (v.neighbours[i][1], v.neighbours[i][2] - capacity, add_edge)
            return v.neighbours[i][2]
        end
    end
    return typemin(Int64)
end

function augment(path::Vector{Vertex})
    for i in 1:(length(path) - 1)
        v, w = path[i], path[i + 1]
        new_capacity_forward = augment_arc(v, w, 1, true)
        @assert new_capacity_forward == 0
        new_capacity_backward = augment_arc(w, v, -1, false)
        @assert new_capacity_backward == 1
        
    end
end

function find_biggest_matching(filename::Union{String, Nothing}, graph::Graph_struct, degree::Int64, print_matching::Bool)::Int64
    s = Vertex(Int64(0))
    t = Vertex(Int64(2^(graph.k+1) + 1))

    for v in graph.V1
        push!(s.neighbours, (v, 1, false))
        push!(v.neighbours, (s, 0, false))
    end

    for w in graph.V2
        push!(t.neighbours, (w, 0, false))
        push!(w.neighbours, (t, 1, false))
    end

    if filename != nothing
        save_to_model(filename, graph, s.neighbours, graph.k, degree, print_matching)
    end

    matching_size = 0
    t.labeled = true

    while t.labeled

        list = Queue{Vertex}()
        pred = Dict{Vertex, Vertex}()

        for v in graph.V1
            v.labeled = false
        end

        for v in graph.V2
            v.labeled = false
        end

        t.labeled = false

        enqueue!(list, s)
        s.labeled = true

        while !isempty(list) && !t.labeled
            v = dequeue!(list)
            for (w, capacity, _) in v.neighbours
                if capacity > 0 && !w.labeled
                    w.labeled = true
                    pred[w] = v
                    enqueue!(list, w)
                end
            end
        end

        if t.labeled
            path = reconstruct_path(pred, s, t)
            augment(path)
            matching_size += 1
        end
    end

    @assert matching_size <= 2^(graph.k)

    return matching_size
end

function print_path(path::Vector{Vertex})
    for v in path
        print(v.value, "->")
    end
    println()
end

function save_to_model(filename::String, graph::Graph_struct, s_neighbours::Vector{Tuple{Vertex, Int64, Bool}}, k::Int64, degree::Int64, printFlow::Bool)
    open("lp/edges.txt", "w") do file

        for (v, capacity, _) in s_neighbours
            println(file, 0, " ", v.value, " ", capacity)
        end

        for v in graph.V1
            for (w, capacity, _) in v.neighbours
                if capacity > 0
                    println(file, v.value, " ", w.value, " ", capacity)
                end
            end
        end

        for w in graph.V2
            for (v, capacity, _) in w.neighbours
                if capacity > 0
                    println(file, w.value, " ", v.value, " ", capacity)
                end
            end
        end
    end

    open("lp/$filename", "w") do file
        println(file, "using JuMP")
        println(file, "using GLPK")
        println(file, "")
        println(file, "function read_edges(filename::String)::Dict{Tuple{Int64, Int64}, Int64}")
        println(file, "    edges = Dict{Tuple{Int64, Int64}, Int64}()")
        println(file, "    open(filename) do file")
        println(file, "        for line in eachline(file)")
        println(file, "            v, w, capacity = split(line)")
        println(file, "            edges[(parse(Int64, v), parse(Int64, w))] = parse(Int64, capacity)")
        println(file, "        end")
        println(file, "    end")
        println(file, "    return edges")
        println(file, "end")
        println(file, "")
        println(file, "k = ", k)
        println(file, "degree = ", degree)
        println(file, "vertices = [i for i in 0:(2^(k+1) + 1)]")
        println(file, "edges = read_edges(\"edges.txt\")")
        println(file, "")
        println(file, "start = vertices[1]")
        println(file, "finish = vertices[2^(k+1) + 2]")
        println(file, "")
        println(file, "")
        println(file, "model = Model(GLPK.Optimizer)")
        println(file, "@variable(model, flow[e in keys(edges)] >= 0)")
        println(file, "for e in keys(edges)")
        println(file, "    @constraint(model, flow[e] <= edges[e])")
        println(file, "end")
        println(file, "")
        println(file, "for v in vertices")
        println(file, "    if v != start && v != finish")
        println(file, "        @constraint(model, sum(flow[(u, v)] for u in vertices if (u, v) in keys(edges)) == sum(flow[(v, w)] for w in vertices if (v, w) in keys(edges)))")
        println(file, "    end")
        println(file, "end")
        println(file, "")
        println(file, "@objective(model, Max, sum(flow[(start, v)] for v in vertices if (start, v) in keys(edges)))")
        println(file, "")
        println(file, "time_bipartite = @elapsed begin")
        println(file, " optimize!(model)")
        println(file, "end")
        println(file, "")
        println(file, "println(\"MATCHING SIZE: \", objective_value(model))")
        println(file, "open(\"../test/bm_lp.log\", \"w\") do stderror")
        println(file, "    redirect_stderr(stderror) do")
        println(file, "        println(stderr, k, \" \", degree, \" \", time_bipartite)")
        println(file, "    end")
        println(file, "end")

        if printFlow
            println(file, "println(\"SELECTED EDGES:\")")
            println(file, "for (v, w) in keys(edges)")
            println(file, "    if v != start && w != finish")
            println(file, "        if value(flow[(v, w)]) > 0")
            println(file, "            println(v, \" -> \", w)")
            println(file, "        end")
            println(file, "    end")
            println(file, "end")
        end
    end

    println("Saved to lp.jl")
end
end
