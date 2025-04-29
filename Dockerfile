FROM nvidia/cuda:12.1.1-cudnn8-runtime-ubuntu22.04

ARG JULIA_VERSION=1.11.5

# install system deps then Julia
RUN apt-get update && \
    apt-get install -y --no-install-recommends wget ca-certificates libgomp1 && \
    wget https://julialang-s3.julialang.org/bin/linux/x64/1.11/julia-${JULIA_VERSION}-linux-x86_64.tar.gz && \
    tar xf julia-*.tar.gz -C /opt/ && \
    ln -s /opt/julia-${JULIA_VERSION}/bin/julia /usr/local/bin/julia && \
    rm julia-*.tar.gz && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# copy both TOMLs and precompile exactly your locked versions
COPY Project.toml Manifest.toml ./
RUN julia --project=. -e 'import Pkg; Pkg.instantiate(); Pkg.precompile()'

# now copy the rest and set your entrypoint
COPY . .
ENTRYPOINT ["julia","--project=.","run.jl"]

