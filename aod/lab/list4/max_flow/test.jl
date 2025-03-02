using ArgParse
include("max_flow.jl")
using .max_flow_impl

function test_both(i::Int64, print_flow::Bool, filename::Union{String, Nothing})
    vertices = generate_vertices(i)
    edge_count = generate_edges(vertices, i)
    vertices1 = deepcopy_all(vertices)

    @assert length(vertices) == length(vertices1)
    @assert length(vertices) == 2^i
    @assert edge_count == i * 2^(i - 1)

    if filename != nothing
        save_to_model(vertices, i, print_flow, filename)
    end

    start = vertices[1]
    finish = vertices[2^i]

    time = @elapsed begin
        max_flow, found_paths = edmonds_karp(vertices, start, finish)
    end

    start1 = vertices1[1]
    finish1 = vertices1[2^i]
    time1 = @elapsed begin
        max_flow1, found_paths1 = shortest_augmenting_path(vertices1, start1, finish1)
    end

    @assert max_flow == max_flow1
    @assert found_paths == found_paths1

    println("MAX FLOW: ", max_flow)

    if print_flow
        println("FLOW ON EDGES(edmonds karp):") 
        for v in vertices
            for (w, _, flow) in v.neighbours
                if flow > 0
                    println(v.value, " -> ", w.value, " : ", flow)
                end
            end
        end

        println()
        println("FLOW ON EDGES(shortest augmenting path):")
        for v in vertices1
            for (w, _, flow) in v.neighbours
                if flow > 0
                    println(v.value, " -> ", w.value, " : ", flow)
                end
            end
        end
    end

    open("test/ek.log", "a") do stderror
        redirect_stderr(stderror) do
            println(stderror, i, " ", time, " ", found_paths)
        end
    end

    open("test/sap.log", "a") do stderror
        redirect_stderr(stderror) do
            println(stderror, i, " ", time1, " ", found_paths1)
        end
    end

    
end

function test_max_flow_ek(i::Int64, printFlow::Bool)
    vertices = generate_vertices(i)
    edge_count = generate_edges(vertices, i)

    start = vertices[1]
    finish = vertices[2^i]

    time = @elapsed begin
        max_flow, found_paths = edmonds_karp(vertices, start, finish)
    end

    println("MAX FLOW: ", max_flow)
    

    if print_flow
        for v in vertices
            for (w, _, flow) in v.neighbours
                if flow > 0
                    println(v.value, " -> ", w.value, " : ", flow)
                end
            end
        end
    end

    open("test/ek.log", "a") do stderror
        redirect_stderr(stderror) do
            println(stderror, i, " ", time, " ", found_paths)
        end
    end
end

function test_max_flow_sap(i::Int64, printFlow::Bool, filename::Union{String, Nothing})
    vertices = generate_vertices(i)
    edge_count = generate_edges(vertices, i)

    if filename != nothing
        save_to_model(vertices, i, printFlow, filename)
    end

    start = vertices[1]
    finish = vertices[2^i]


    time = @elapsed begin
        max_flow, found_paths = shortest_augmenting_path(vertices, start, finish)
    end

    println("MAX FLOW: ", max_flow)
    

    if printFlow
        for v in vertices
            for (w, _, flow) in v.neighbours
                if flow > 0
                    println(v.value, " -> ", w.value, " : ", flow)
                end
            end
        end
    end

    open("test/sap.log", "a") do stderror
        redirect_stderr(stderror) do
            println(stderror, i, " ", time, " ", found_paths)
        end
    end


end

function test_for_plots()
    for i in 1:16
        println("I: ", i, "--------------------------------------------------")
        # max_flow_avg = 0
        # time_ek_avg = 0
        time_sap_avg = 0
        # found_paths_avg = 0

        for j in 1:10
            println(j)
            vertices = generate_vertices(i)
            edge_count = generate_edges(vertices, i)
            # vertices1 = deepcopy_all(vertices)

            # @assert length(vertices) == length(vertices1)
            @assert length(vertices) == 2^i
            @assert edge_count == i * 2^(i - 1)

            # start = vertices[1]
            # finish = vertices[2^i]
            # time = @elapsed begin
            #     max_flow, found_paths = edmonds_karp(vertices, start, finish)
            # end

            start1 = vertices[1]
            finish1 = vertices[2^i]
            time1 = @elapsed begin
                max_flow1, found_paths1 = shortest_augmenting_path(vertices, start1, finish1)
            end

            # @assert max_flow == max_flow1
            # @assert found_paths == found_paths1

            # max_flow_avg += max_flow1
            # time_ek_avg += time
            time_sap_avg += time1
            # found_paths_avg += found_paths1

            # open("test/ek.txt", "a") do file
            #     println(file, i, " ", time)
            # end

            open("test/sap1.txt", "a") do file
                println(file, i, " ", time1)
            end

            # open("test/utils.txt", "a") do file
            #     println(file, i, " ", max_flow1, " ", found_paths1)
            # end
        end

        # max_flow_avg /= 10
        # time_ek_avg /= 10
        time_sap_avg /= 10
        # found_paths_avg /= 10

        # open("test/ek_avg.txt", "a") do file
        #     println(file, i, " ", time_ek_avg)
        # end

        open("test/sap_avg1.txt", "a") do file
            println(file, i, " ", time_sap_avg)
        end

        # open("test/utils_avg.txt", "a") do file
        #     println(file, i, " ", max_flow_avg, " ", found_paths_avg)
        # end
    end
end

function parse_command_line()
    parser = ArgParseSettings()
    @add_arg_table parser begin
        "--size"
            help = "Size of the graph"
            arg_type = Int64
            required = true
        "--printFlow"
            help = "Print flow on edges"
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

    test_both(args["size"], args["printFlow"], args["glpk"])
end

main()