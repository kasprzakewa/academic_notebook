using JuMP
using GLPK

function read_edges(filename::String)::Dict{Tuple{Int64, Int64}, Int64}
    edges = Dict{Tuple{Int64, Int64}, Int64}()
    open(filename) do file
        for line in eachline(file)
            v, w, capacity = split(line)
            edges[(parse(Int64, v), parse(Int64, w))] = parse(Int64, capacity)
        end
    end
    return edges
end

k = 4
vertices = [i for i in 0:(2^k - 1)]
edges = read_edges("edges.txt")

start = vertices[1]
finish = vertices[2^k]


model = Model(GLPK.Optimizer)
time_all = @elapsed begin
@variable(model, flow[e in keys(edges)] >= 0)
for e in keys(edges)
    @constraint(model, flow[e] <= edges[e])
end

for v in vertices
    if v != start && v != finish
        @constraint(model, sum(flow[(u, v)] for u in vertices if (u, v) in keys(edges)) == sum(flow[(v, w)] for w in vertices if (v, w) in keys(edges)))
    end
end

@objective(model, Max, sum(flow[(start, v)] for v in vertices if (start, v) in keys(edges)))

time_max_flow = @elapsed begin
 optimize!(model)
end
end

println("MAX FLOW: ", objective_value(model))

open("./test/mf_lp_table.log", "a") do stderror
    redirect_stderr(stderror) do
        println(stderror, k, " ", objective_value(model))
    end
end

open("./test/mf_lp.log", "a") do stderror
    redirect_stderr(stderror) do
        println(stderr, k, " ", time_max_flow, " ", time_all)
    end
end
println("FLOW ON EDGES:")
for e in keys(edges)
    println(e, ": ", value(flow[e]))
end
