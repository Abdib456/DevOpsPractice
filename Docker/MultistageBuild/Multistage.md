# Docker Multi-Stage Builds

## 1. What Are Multi-Stage Builds?

A multi-stage build uses **multiple `FROM` instructions** in a single Dockerfile to separate the build process from the final production image.

The main goal is to create **smaller, cleaner and more secure Docker images** by keeping unnecessary build tools out of production.

## 2. Stage 1 — Build Stage

The **build stage** is where the application is prepared for production.

- Installs build tools, compilers and development dependencies.
- Compiles source code or prepares application dependencies when required.
- Produces the files or packages needed to run the application.
- Can contain tools that are unnecessary once the application is built.

**Key point:** Stage 1 prepares the application. We only need to transfer the necessary output into production, not all the tools used to create it.

## 3. Stage 2 — Production Stage

The **production stage** creates the final Docker image that will run as a container.

- Starts fresh using another `FROM` instruction.
- Uses `COPY --from=builder` to transfer the necessary files from Stage 1.
- Includes the application and any runtime dependencies required.
- Leaves behind unnecessary compilers, development tools and temporary build files.

**Key point:** Stage 2 contains what the application needs to **run**, rather than everything needed to **build** it.

### Example — Building a Simple Go Web Application

Imagine we have a small website written in Go, a programming language commonly used for backend applications.

When someone visits the website, it displays:

```text
Hello from my Go application!
```

The application needs to run a web server to receive requests from a browser and return that message.

Our project looks like this:

```text
my-go-app/
├── main.go
├── go.mod
└── Dockerfile
```

- `main.go` — Contains the application code, including the web server.
- `go.mod` — Defines the Go module and its dependencies.
- `Dockerfile` — Instructions for building the Docker image.

**The important part:** Go code can be compiled into an executable file. An executable is a program that can be run directly.

We will name that executable `server`. This is simply a filename we choose, not a separate server or container.

### Multi-Stage Dockerfile

```dockerfile
# Stage 1: Build the application
FROM golang:1.25 AS builder

WORKDIR /app

# Copy the application source code
COPY . .

# Compile the Go application into an executable named server
RUN CGO_ENABLED=0 go build -o server .

# Stage 2: Create the production image
FROM alpine:3.22

WORKDIR /app

# Copy only the compiled application from Stage 1
COPY --from=builder /app/server ./server

EXPOSE 8080

# Start the application when the container runs
CMD ["./server"]
```

### How Does This Work?

**Stage 1 — Building the application**

1. `FROM golang:1.25 AS builder` starts the build stage with Go and its development tools installed.
2. `COPY . .` copies the project files into `/app`.
3. `RUN CGO_ENABLED=0 go build -o server .` compiles the Go source code into an executable named `server`. `CGO_ENABLED=0` helps produce a standalone executable for this example.

At this point, we have a finished program that can run without the Go compiler.

**Stage 2 — Running the application**

1. `FROM alpine:3.22` starts a fresh, lightweight image without the Go development tools.
2. `COPY --from=builder /app/server ./server` copies the compiled executable from Stage 1 into Stage 2.
3. `EXPOSE 8080` documents the port our example web application uses.
4. `CMD ["./server"]` runs the compiled application when the container starts.

The `./server` command simply means **run the executable named `server` in the current directory**. It doesn't create a new server.

We can build and run the image:

```bash
docker build -t go-web:v1 .
docker run -p 8080:8080 go-web:v1
```

Assuming the Go application listens on port 8080, visiting `http://localhost:8080` displays the website's message.

### Why Is This Better?

Without multi-stage builds, we might use the large Go development image to both build and run our application.

With multi-stage builds:

- Stage 1 uses the Go compiler to create the executable.
- Stage 2 receives only the finished executable.
- The final image doesn't need the Go compiler, source code or build tools.

**Remember:** Not every application produces a standalone executable. Python applications, for example, still need the Python interpreter and installed runtime packages in the production stage.

## 4. Benefits and Common Practices

- **Smaller images:** Excludes unnecessary compilers, development packages and temporary build files.
- **Better security:** Reduces unnecessary software and potential vulnerabilities in production.
- **Faster deployment:** Smaller images generally take less time to push, pull and distribute.
- **Cleaner environments:** Separates build requirements from runtime requirements.

**Common practices:**

- Name build stages using `AS build` or `AS builder`.
- Use lightweight, supported base images.
- Copy only necessary files and dependencies into the final stage.
- Use `.dockerignore` to exclude unnecessary files from the build context.
- Keep build-time tools in Stage 1 and runtime dependencies in Stage 2.

## 5. Common Mistakes to Avoid

- **Forgetting application dependencies:** Copying application code doesn't automatically copy installed packages.
- **Missing runtime libraries:** Compiled dependencies may require additional system libraries in the final stage.
- **Assuming stages share files:** Each `FROM` starts a separate stage. Files must be explicitly copied between stages.
- **Copying everything:** Avoid transferring unnecessary build tools into production.
- **Forgetting to rebuild:** After changing your Dockerfile, use `docker compose up --build` to rebuild the image.

## 6. Building and Tagging Images

Build version 1:

```bash
docker build -t myapp:v1 .
```

Build version 2 after making changes:

```bash
docker build -t myapp:v2 .
```

View your images:

```bash
docker images
```

**Remember:** Tags identify image versions. Building twice doesn't guarantee different image IDs if the build inputs haven't changed.

---

## Key Takeaway

**Stage 1 = Build and prepare the application.**

**Stage 2 = Run the application with only the necessary files and runtime dependencies.**

Multi-stage builds reduce image size and unnecessary software while keeping everything required for the application to run.
