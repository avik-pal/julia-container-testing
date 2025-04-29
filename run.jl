using Lux, CUDA

if CUDA.has_cuda()
    println("Running on GPU")
    # GPU paths…
else
    println("Running on CPU")
    # CPU fallback…
end
