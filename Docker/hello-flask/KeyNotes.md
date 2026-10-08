# Docker

## 1. Introduction to Docker

Docker is a containerisation platform that allows applications to run inside **containers**, providing a consistent environment across different machines.

Containers package an application with its dependencies, libraries and runtime, reducing issues where an application works on one machine but not another.

**Key concepts:**

- **Dockerfile:** A file containing instructions for building a Docker image.
- **Docker Image:** A packaged application containing its code, dependencies and runtime.
- **Docker Container:** An instance of an image that can be started, stopped and removed.
- **Docker Engine:** The software responsible for building images and running containers.

The basic workflow is:

`Dockerfile → Docker Image → Docker Container`

### Docker Desktop vs Docker Hub

**Docker Desktop** is an application that provides Docker tools and a graphical interface (GUI) for managing images and containers locally. It is particularly useful on Windows and macOS.

**Docker Hub** is an online registry where Docker images are stored and shared.

- Images such as `python:3.8-slim`, `nginx` and `ubuntu` can be downloaded from Docker Hub.
- `docker pull` downloads images from a registry.
- `docker push` uploads images to a registry (authentication and permissions required).
- When building an image, Docker automatically pulls the base image if it isn't available locally.

Docker Desktop is used to **manage Docker locally**, whereas Docker Hub is used to **store and distribute images**.

---

## 2. Installing and Verifying Docker

After installing Docker, verify the installation using:

```bash
docker --version
docker run hello-world
```

- `docker --version` displays the installed Docker CLI version.
- `docker run hello-world` downloads the image if needed and runs a test container to confirm Docker is working.

---

## 3. Creating a Dockerfile

For this task, I containerised a simple Python Flask application.

The Dockerfile defines how the application image should be built.

| Instruction | Purpose |
|---|---|
| `FROM python:3.8-slim` | Uses a lightweight Python base image |
| `WORKDIR /app` | Sets the working directory inside the image |
| `COPY . .` | Copies project files into the image's working directory |
| `RUN pip install flask` | Installs Flask during the image build |
| `EXPOSE 5002` | Documents the port the application listens on |
| `CMD ["python", "app.py"]` | Specifies the default command when the container starts |

**Important distinctions:**

- `RUN` executes commands when building an image.
- `CMD` specifies the command executed when starting a container.
- `EXPOSE` documents the container port but does not publish it to the host.
- `WORKDIR` sets the directory where subsequent instructions operate.

For future projects, dependencies can be stored in a `requirements.txt` file rather than installed individually.

---

## 4. Building and Running a Container

### Build an image

```bash
docker build -t myapp .
```

- `docker build` builds an image from the Dockerfile.
- `-t myapp` assigns the image a name/tag.
- `.` specifies the current directory as the build context.

### Run a container

```bash
docker run -p 5002:5002 myapp
```

This creates and starts a container using the `myapp` image.

The `-p` flag maps a host port to a container port.

**Format:** `-p HOST_PORT:CONTAINER_PORT`

For example:

```bash
docker run -p 8080:5002 myapp
```

This maps port `8080` on the host machine to port `5002` inside the container.

The Flask application can then be accessed at `http://localhost:8080`.

### Run in detached mode

```bash
docker run -d -p 8080:5002 myapp
```

The `-d` flag runs the container in the background, allowing the terminal to remain available.

You can also give the container a name:

```bash
docker run -d --name mycontainer -p 8080:5002 myapp
```

---

## 5. Managing Docker Containers

Once containers are running, Docker provides commands to inspect and manage them.

| Command | Purpose |
|---|---|
| `docker ps` | Lists currently running containers |
| `docker ps -a` | Lists all containers, including stopped ones |
| `docker stop <container>` | Stops a running container |
| `docker start <container>` | Starts an existing stopped container |
| `docker restart <container>` | Restarts a container |
| `docker rm <container>` | Removes a stopped container |
| `docker rm -f <container>` | Force-removes a running container |
| `docker logs <container>` | Displays container logs |
| `docker logs -f <container>` | Continuously follows container logs |
| `docker exec -it <container> /bin/sh` | Opens an interactive shell inside a running container |

`<container>` can be replaced with the container's name or ID, which can be found using `docker ps -a`.

**Important:** Stopping a container does not delete it. It can be restarted using `docker start`. Removing a container deletes that container, but not the image it was created from.

---

## 6. Managing Docker Images

| Command | Purpose |
|---|---|
| `docker images` | Lists locally stored images |
| `docker pull <image>` | Downloads an image from a registry |
| `docker rmi <image>` | Removes a local image |
| `docker image prune` | Removes unused dangling images |
| `docker push <image>` | Uploads an appropriately tagged image to a registry |

**Image vs Container:**

An image is a reusable template, while a container is an instance created from that image.

Multiple containers can be created from the same image, each running independently.

---

## 7. Basic Docker Troubleshooting

When an application running inside a container cannot be accessed, a useful troubleshooting process is:

1. **Check running containers:** `docker ps` — confirm the container is running.
2. **Check stopped containers:** `docker ps -a` — identify whether the container exited.
3. **Inspect logs:** `docker logs <container>` — check for application errors.
4. **Check port mappings:** `docker ps` — verify the correct host and container ports are published.
5. **Inspect inside the container:** `docker exec -it <container> /bin/sh` — investigate files and the environment.

For web applications, also confirm that the application listens on `0.0.0.0` rather than only `127.0.0.1` inside the container, so it can receive traffic through Docker's port mapping.

---

## 8. Key Takeaways

- Docker packages applications into containers to provide consistent environments.
- Dockerfiles define how images are built.
- Images are used to create containers.
- Docker Hub stores and distributes images, while Docker Desktop helps manage Docker locally.
- `docker build` creates an image, while `docker run` creates and starts a container.
- `-p` publishes container ports to the host, while `-d` runs containers in the background.
- `docker ps`, `docker logs` and `docker exec` are essential for managing and troubleshooting containers.

**Overall workflow:**

`Write Application → Dockerfile → Build Image → Run Container → Access Application`

This task covered the fundamentals of building, running and managing a containerised Python application.
