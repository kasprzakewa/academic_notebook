using ArgParse
include("bipartite_matching.jl")
using .bipartite_matching

function test_bipartite_matching(size::Int64, degree::Int64, printMatching::Bool, filename::Union{String, Nothing})
    graph = Graph_struct(size)
    add_edges(graph, degree)

    if printMatching
        println("EDGES:")
        for v in graph.V1
            for (w, capacity, _) in v.neighbours
                if capacity > 0
                    println(v.value, " -> ", w.value)
                end
            end
        end
    end

    time = @elapsed begin
        matching = find_biggest_matching(filename, graph, degree, printMatching)
    end

    println("MATCHING SIZE: ", matching)

    if printMatching
        println("SELECTED EDGES:")
        for v in graph.V1
            for (w, _, matched) in v.neighbours
                if matched
                    println(v.value, " -> ", w.value)
                end
            end
        end
    end

    open("test/bm.log", "a") do stderror
        redirect_stderr(stderror) do
            println(stderror, size, " ", degree, " ", time)
        end
    end
end

function test_for_plots()
    for size in 1:10
        println("SIZE: ", size, "------------------------------------")
        for degree in 1:size
            println("DEGREE: ", degree)
            time_avg = 0
            matching_avg = 0
            for j in 1:10
                println(j)
                graph = Graph_struct(size)
                add_edges(graph, degree)

                time = @elapsed begin
                    matching = find_biggest_matching(nothing, graph, degree, false)
                end

                time_avg += time
                matching_avg += matching

                open("test/bm.txt", "a") do file
                    println(file, size, " ", degree, " ", time, " ", matching)
                end
            end

            time_avg /= 10
            matching_avg /= 10

            open("test/bm_avg.txt", "a") do file
                println(file, size, " ", degree, " ", time_avg, " ", matching_avg)
            end
        end
    end
end

function parse_command_line()
    parser = ArgParseSettings()
    @add_arg_table parser begin
        "--size"
            help = "Size of the graph"
            arg_type = Int64
            required = true
        "--degree"
            help = "Degree of each vertex from V1"
            arg_type = Int64
            required = true
        "--printMatching"
            help = "Print matching"
            action = :store_true
        "--glpk"
            help = "GLPK file name"
            arg_type = String
            required = false
    end
    
    return parse_args(parser)
end

function main()
    args = parse_command_line()
    test_bipartite_matching(args["size"], args["degree"], args["printMatching"], args["glpk"])
end

test_for_plots()

