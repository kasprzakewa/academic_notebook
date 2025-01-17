module max_flow_impl

export  edmonds_karp, distance_label, has_admissible_arc, retreat, shortest_augmenting_path,
        generate_vertices, generate_edges,
        Vertex, deepcopy_vertex, reconstruct_path,
        find_min_capacity, find_neighbour, augment,
        print_path, deepcopy_all, save_to_model 

using DataStructures
using Random

mutable struct Vertex
    value::Int64
    label::Vector{Int64}
    h::Int64
    labeled::Bool
    num_of_edges::Int64
    neighbours::Vector{Tuple{Vertex, Int64, Int64}}
    d::Int64

    Vertex(value, label, h, labeled, num_of_edges, neighbours, d) = new(value, label, h, labeled, num_of_edges, neighbours, d)
    Vertex(value, label, h) = new(value, label, h, false, 0, Vector{Tuple{Vertex, Int64, Int64}}(), typemax(Int64))
end

function deepcopy_vertex(vertex::Vertex, visited::Dict{Vertex, Vertex})::Vertex
    if haskey(visited, vertex)
        return visited[vertex]
    end

    copy_vertex = Vertex(
        vertex.value,
        copy(vertex.label),
        vertex.h,
        vertex.labeled,
        vertex.num_of_edges,
        [],
        vertex.d
    )

    visited[vertex] = copy_vertex

    for (neighbour, capacity, flow) in vertex.neighbours
        push!(copy_vertex.neighbours, (deepcopy_vertex(neighbour, visited), capacity, flow))
    end

    return copy_vertex
end


function deepcopy_all(vertices::Vector{Vertex})::Vector{Vertex}
    visited = Dict{Vertex, Vertex}()
    return [deepcopy_vertex(vertex, visited) for vertex in vertices]
end


function generate_vertices(k::Int64)::Vector{Vertex}
    return [Vertex(i, reverse(digits(i, base=2, pad=k)), sum(reverse(digits(i, base=2, pad=k)))) for i in 0:(2^k - 1)]
end

function generate_edges(vertices::Vector{Vertex}, k::Int64)::Int64
    edge_count = 0
    for i in 1:length(vertices)
        seed = rand(1:typemax(UInt64))
        rng = MersenneTwister(seed)
        v = vertices[i]
        for j in (i+1):length(vertices)
            w = vertices[j]
            if sum(v.label .!= w.label) == 1
                l = max(v.h, k - v.h, w.h, k - w.h)
                capacity = rand(rng, 1:(2^l))
                push!(v.neighbours, (w, capacity, 0))  # Pojemność i początkowy przepływ = 0
                push!(w.neighbours, (v, 0, 0))
                v.num_of_edges += 1
                w.num_of_edges += 1
                edge_count += 1
            end
        end
    end
    return edge_count
end

function edmonds_karp(vertices::Vector{Vertex}, start::Vertex, finish::Vertex)::Tuple{Int64, Int64}

    max_flow = 0
    found_paths = 0

    finish.labeled = true

    while finish.labeled

        list = Queue{Vertex}()
        pred = Dict{Vertex, Vertex}()

        for v in vertices
            v.labeled = false
        end

        enqueue!(list, start)
        start.labeled = true

        while !isempty(list) && !finish.labeled
            v = dequeue!(list)
            for (w, capacity) in v.neighbours
                if capacity > 0 && !w.labeled
                    w.labeled = true
                    pred[w] = v
                    enqueue!(list, w)
                end
            end
        end

        if finish.labeled

            path = reconstruct_path(pred, start, finish)
            min_capacity = find_min_capacity(path)

            max_flow += min_capacity
            found_paths += 1
            augment(path, min_capacity)
        end
    end

    return (max_flow, found_paths)
end

function shortest_augmenting_path(vertices::Vector{Vertex}, start::Vertex, finish::Vertex)::Tuple{Int64, Int64}
    max_flow = 0
    found_paths = 0
    distance_label(vertices, finish)
    pred = Dict{Vertex, Vertex}()
    i = start

    while start.d < length(vertices)
        j = has_admissible_arc(i)
        if j != nothing
            pred[j] = i
            i = j
            if i == finish
                path = reconstruct_path(pred, start, finish)
                min_capacity = find_min_capacity(path)
                augment(path, min_capacity)
                max_flow += min_capacity
                found_paths += 1
                i = start
                pred = Dict{Vertex, Vertex}()
            end
        else
            retreat(i)
            if i != start
                temp = pred[i]
                delete!(pred, i)
                i = temp
            end
        end
    end

    return (max_flow, found_paths)
end

function distance_label(vertices::Vector{Vertex}, sink::Vertex)
    for v in vertices
        v.d = typemax(Int64)
    end
    sink.d = 0
    queue = [sink]
    while !isempty(queue)
        current = popfirst!(queue)
        for (neighbor, capacity) in current.neighbours
            if capacity == 0
                if neighbor.d == typemax(Int64)
                    neighbor.d = current.d + 1
                    push!(queue, neighbor)
                end
            end
            
        end
    end
end

function has_admissible_arc(v::Vertex)::Union{Vertex, Nothing}
    for i in 1:length(v.neighbours)
        if v.neighbours[i][2] > 0 && v.neighbours[i][1].d == v.d - 1
            return v.neighbours[i][1]
        end
    end
    return nothing
end

function retreat(v::Vertex)
    min_d = typemax(Int64) - 1

    for n in v.neighbours
        if n[2] > 0
            min_d = min(min_d, n[1].d)
        end
    end
    
    v.d = min_d + 1
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

function find_min_capacity(path::Vector{Vertex})::Int64
    min_capacity = typemax(Int64)
    for i in 1:(length(path) - 1)
        v, w = path[i], path[i + 1]
        for (neighbor, capacity, _) in v.neighbours
            if capacity > 0 && neighbor == w
                min_capacity = min(min_capacity, capacity)
                break
            end
        end
    end
    return min_capacity
end

function find_neighbour(v::Vertex, w::Vertex)::Int64
    for i in 1:length(v.neighbours)
        if v.neighbours[i][1] == w
            return i
        end
    end
    return 0
end

function augment(path::Vector{Vertex}, min_capacity::Int64)
    for i in 1:(length(path) - 1)
        v, w = path[i], path[i + 1]
        index_w = find_neighbour(v, w)
        v.neighbours[index_w] = (v.neighbours[index_w][1], v.neighbours[index_w][2] - min_capacity, v.neighbours[index_w][3] + min_capacity)
        index = find_neighbour(w, v)
        w.neighbours[index] = (w.neighbours[index][1], w.neighbours[index][2] + min_capacity, w.neighbours[index][3] - min_capacity)
    end
end

function print_path(path::Vector{Vertex})
    for v in path
        print(v.value, "->")
    end
    println()
end

function save_to_model(vertices::Vector{Vertex}, k::Int64, printFlow::Bool, filename::String)
    open("lp/edges.txt", "w") do file
        for v in vertices
            for (w, capacity, _) in v.neighbours
                if capacity > 0
                    println(file, v.value, " ", w.value, " ", capacity)
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
        println(file, "vertices = [i for i in 0:(2^k - 1)]")
        println(file, "edges = read_edges(\"edges.txt\")")
        println(file, "")
        println(file, "start = vertices[1]")
        println(file, "finish = vertices[2^k]")
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
        println(file, "time_max_flow = @elapsed begin")
        println(file, " optimize!(model)")
        println(file, "end")
        println(file, "")
        println(file, "println(\"MAX FLOW: \", objective_value(model))")
        println(file, "open(\"../test/mf_lp.log\", \"w\") do stderror")
        println(file, "    redirect_stderr(stderror) do")
        println(file, "        println(stderr, k, \" \", time_max_flow)")
        println(file, "    end")
        println(file, "end")

        if printFlow
            println(file, "println(\"FLOW ON EDGES:\")")
            println(file, "for e in keys(edges)")
            println(file, "    println(e, \": \", value(flow[e]))")
            println(file, "end")
        end
    end

    println("Saved to lp.jl")
end

end