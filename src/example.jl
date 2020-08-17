include("JuliaNature.jl")
f(x1, x2) = (x1 + 2 * x2 - 7)^2 + (2 * x1 + x2 - 5)^2
model = JuliaNature.initialize(25, 2, f, [0, 1.0], [-10.0, 10.0], [0.0, 2.0], [0, 1.0], 0)
println(JuliaNature.optimize(model, 10000))