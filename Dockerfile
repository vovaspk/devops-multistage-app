# ---------- Stage 1: BUILD ----------
# Big image: contains the Go compiler and all build tools (~300+ MB).
# We need it only to turn main.go into one executable file.
FROM golang:1.23-alpine AS build

WORKDIR /src

# Copy go.mod first, source later: Docker caches layers, so changing
# main.go does not invalidate the layers above it (best practice #4).
COPY go.mod ./
COPY main.go ./

# CGO_ENABLED=0 -> fully static binary, so it runs on a minimal base image.
RUN CGO_ENABLED=0 go build -o /out/app .

# ---------- Stage 2: RUNTIME ----------
# Small image: only what is needed to RUN the binary (~10 MB).
# Everything from stage 1 (compiler, sources, caches) is thrown away.
FROM alpine:3.20

# Run as a non-root user (best practice #7).
RUN adduser -D -u 10001 app
USER app

# The key line: take ONLY the compiled binary from the "build" stage.
COPY --from=build /out/app /app

EXPOSE 8080
ENTRYPOINT ["/app"]
