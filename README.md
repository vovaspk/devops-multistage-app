# devops-multistage-app

Tiny Go HTTP server used to demonstrate a Docker **multi-stage build** (DevOps course, homework 2, task 8).

## Idea

| Dockerfile | What the final image contains | Size |
|---|---|---|
| `Dockerfile.single-stage` | Go compiler + sources + binary | ~471 MB on disk |
| `Dockerfile` (multi-stage) | only the compiled binary on Alpine | ~25 MB on disk |

Stage 1 (`golang:alpine`) compiles `main.go`. Stage 2 (`alpine`) copies only the binary with
`COPY --from=build`. The compiler and sources never reach the final image.

## Run

```bash
docker build -t multistage-app:multi .
docker run -d --name multistage-app -p 8080:8080 multistage-app:multi
curl localhost:8080
curl localhost:8080/health
```

## Compare with single-stage

```bash
docker build -t multistage-app:single -f Dockerfile.single-stage .
docker images multistage-app
```

## Docker Hub image

<!-- TODO: paste the link after docker push, e.g. https://hub.docker.com/r/<username>/multistage-app -->
