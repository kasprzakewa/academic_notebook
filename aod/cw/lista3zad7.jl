using JuMP
using GLPK

model = Model(GLPK.Optimizer)

@variable(model, x1, Bin)
@variable(model, x2, Bin)
@variable(model, x3, Bin)

@constraint(model, x1 - x2 - x3 >= -1)

@constraint(model, x2 - x3 >= 0)

@constraint(model, x1 - x2 + x3 >= 0)

@constraint(model, -x1 + x3 >= 0)

@objective(model, Min, 0)

optimize!(model)

if termination_status(model) == MOI.OPTIMAL
    println("Formuła jest spełnialna!")
    println("x1 = ", value(x1))
    println("x2 = ", value(x2))
    println("x3 = ", value(x3))
else
    println("Formuła nie jest spełnialna.")
end
