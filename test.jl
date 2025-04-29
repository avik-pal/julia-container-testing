# test.jl
using Lux, LuxCUDA

# Check that LuxCUDA is functional (i.e., GPU support is available)
println("LuxCUDA.functional(): ", LuxCUDA.functional())

# Create a random Float32 matrix on the CPU
n = 8
x_cpu = rand(Float32, n, n)
println("x_cpu[1:2,1:2] =", x_cpu[1:2, 1:2])

# Move it to the GPU
x_gpu = gpu(x_cpu)
println("x_gpu type: ", typeof(x_gpu))

# Perform an element-wise computation on the GPU
#   y = x^2 + 3*x + 1
y_gpu = x_gpu .^ 2 .+ 3f0 .* x_gpu .+ 1f0
println("y_gpu[1:2,1:2] =", Array(y_gpu[1:2, 1:2]))

# Compute the sum of all elements on the GPU
s_gpu = sum(y_gpu)
println("sum(y_gpu) = ", s_gpu)
