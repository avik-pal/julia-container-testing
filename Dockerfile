FROM nvidia/cuda:12.6.1-cudnn-devel-ubuntu24.04

ARG JULIA_VERSION=1.11.5
ENV JULIA_CPU_TARGET=generic
ENV JULIA_DEBUG=Reactant_jll
ENV JULIA_DEPOT_PATH=/app/.julia

# Some common packages
RUN apt-get update
RUN apt-get install -y --no-install-recommends \
    build-essential ca-certificates ssh curl wget unzip software-properties-common

WORKDIR /app

# Install Nvidia repo keys
# See: https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#network-repo-installation-for-ubuntu
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb
RUN dpkg -i cuda-keyring_1.1-1_all.deb

# Add ppa:deadsnakes/ppa for better Python support on older Ubuntu releases
RUN add-apt-repository ppa:deadsnakes/ppa -y
RUN apt-get update

# CUDA setup
## Delete uneccessary static libraries
RUN find /usr/local/cuda-*/lib*/ -type f -name 'lib*_static.a' -not -name 'libcudart_static.a' -delete
RUN rm -f /usr/lib/x86_64-linux-gnu/libcudnn_static_v*.a

## Link the libcuda stub to the location where tensorflow is searching for it and
## reconfigure dynamic linker run-time bindings
RUN ln -s /usr/local/cuda/lib64/stubs/libcuda.so /usr/local/cuda/lib64/stubs/libcuda.so.1
RUN echo "/usr/local/cuda/lib64/stubs" > /etc/ld.so.conf.d/z-cuda-stubs.conf
RUN ldconfig

# install Julia via Juliaup
RUN rm -rf juliaup
RUN curl -fsSL https://install.julialang.org | sh -s -- --default-channel ${JULIA_VERSION} --yes --path ./juliaup

# copy both TOMLs and precompile exactly your locked versions
COPY Project.toml sysimage.jl run.jl ./  
RUN ./juliaup/bin/julialauncher --project=. --threads=auto -e 'import Pkg; Pkg.instantiate(); Pkg.precompile()'
RUN ./juliaup/bin/julialauncher --project=. --threads=auto sysimage.jl

RUN ./juliaup/bin/julialauncher -q -JHiFlightSysImage.so -e 'println(Base.loaded_modules)'

chmod 777 -r 

# now copy the rest and set your entrypoint
CMD ["./juliaup/bin/julialauncher", "-q", "-JHiFlightSysImage.so", "--threads=auto", "--project=.", "run.jl"]
