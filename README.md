# Setup Instructions

## Build Docker container

Building from Mac, which is why I'm specifying the arch and using docker buildx

```bash
docker buildx build --platform linux/amd64 --load -t ghcr.io/tyler-korenyi-both/lux-app:amd64 .
```

## Then, pull container from GHCR on HPC

```bash
singularity pull -F --disable-cache --name lux-app.sif docker://ghcr.io/tyler-korenyi-both/lux-app:amd64
```

## Then, run container on HPC

I don't remember exactly the commands, something like this:

```bash
singularity exec lux-app.sif   julia --project=/app -e '
```

## Problem

It seems like the required packages precompile/build fine on the local machine, and then when I try to run the container on HPC, they are either no longer precompiled or they can't be found.
