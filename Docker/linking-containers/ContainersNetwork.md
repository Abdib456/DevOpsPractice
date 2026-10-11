# Docker — Linking Containers

## Overview

**Objective:** Connect a Python Flask application to a MySQL database using a custom Docker network.

**Overall workflow:**

`Create Network → Run MySQL Container → Build Flask Image → Run Flask Container → Verify Connection`

### Understanding the Two Images

**MySQL (Prebuilt Image):**
```text
Docker Hub → Pull MySQL Image → Run Container
```

**Flask (Custom Image):**
```text
Your Code + Dockerfile → Build Image → Run Container
```

MySQL uses an existing image from Docker Hub, whereas Flask requires a custom image containing our application code and dependencies.

### How the Containers Communicate

Both containers are connected to the same user-defined Docker network, but **the network alone doesn't make them communicate — the application code establishes the connection.**

In this exercise:

1. **MySQL (`mydb`)** runs a database server listening on port `3306`.
2. **Flask (`myapp`)** uses `MySQLdb.connect(host="mydb", ...)` to initiate a database connection.
3. Docker's internal DNS resolves `mydb` to the MySQL container's IP address.
4. Flask sends the SQL query `SELECT VERSION()` to MySQL, which processes it and returns the result.
5. Flask displays the returned MySQL version in the browser.

```text
Browser → Flask Container (myapp)
                 |
                 | SQL Query (Port 3306)
                 v
          MySQL Container (mydb)
                 |
                 | Query Result
                 v
          Flask → Browser
```

**In real-world applications**, the same principle applies on a larger scale. For example, an e-commerce application might have a frontend, backend API, database and caching service running in separate containers. They communicate over networks using HTTP requests, database connections and other protocols.

The key concept is that **Docker provides the networking, while the applications themselves determine what data is exchanged.**

---

## 1. Create a Docker Network

```bash
docker network create my-custome-network
```

Creates a user-defined bridge network, allowing containers to communicate using their names rather than manually specifying IP addresses.

For example, Flask connects to MySQL using `host="mydb"`.

## 2. Run the MySQL Container

```bash
docker run -d \
  --name mydb \
  --network my-custome-network \
  -e MYSQL_ROOT_PASSWORD=my-secret-pw \
  mysql:8
```

- `-d` — runs the container in the background.
- `--name` — assigns a container name.
- `--network` — connects it to the custom network.
- `-e` — sets an environment variable (MySQL root password).
- `mysql:8` — uses the existing MySQL image, pulling it from Docker Hub if necessary.

**Issue:** `mysql:5.7` failed because the image didn't support ARM64. Switching to `mysql:8` worked. Also corrected `-- network` to `--network`.

## 3. Build the Flask Image

The Flask application uses `MySQLdb` to connect to `mydb` and runs `SELECT VERSION()` to retrieve the database version.

```bash
docker build -t linking-containers-mysql .
```

- `-t` — assigns a name to the image.
- `.` — uses the current directory as the build context.

**Issues encountered:**

- **Image naming:** Docker repository names must be lowercase.
- **Missing dependencies:** `mysqlclient` required Linux development packages unavailable in `python:3.8-slim`. Fixed by installing `build-essential`, `pkg-config` and `default-libmysqlclient-dev` in the Dockerfile before running `pip install`.

After updating the Dockerfile, the image built successfully.

## 4. Run the Flask Container

```bash
docker run -d \
  --name myapp \
  --network my-custome-network \
  -p 5002:5002 \
  linking-containers-mysql
```

Starts Flask on the same Docker network as MySQL.

- `-p 5002:5002` — maps the Mac's port 5002 to Flask's container port 5002.
- `--network` — allows Flask to reach MySQL through the shared network.

**Important:** MySQL doesn't need a published host port because Flask connects to it internally through Docker's network.

## 5. Verify the Connection

```bash
docker ps
docker logs myapp
```

- `docker ps` — confirmed both containers were running.
- `docker logs myapp` — showed Flask running and an HTTP `200` response.

Accessed `http://localhost:5002`, where Flask returned:

```text
Hello, World! MySQL version: <version>
```

This confirmed that Flask could communicate with MySQL.

## 6. Stop and Inspect Containers

```bash
docker stop myapp
docker stop mydb
docker ps
docker ps -a
```

- `docker stop` — stops containers without deleting them.
- `docker ps` — shows running containers.
- `docker ps -a` — shows all containers, including stopped ones.

To restart the existing containers:

```bash
docker start mydb
docker start myapp
```

---

## Key Takeaways

- Prebuilt images (e.g. `mysql:8`) can be pulled and run directly.
- Custom applications require building an image using a Dockerfile.
- User-defined Docker networks allow containers to communicate by container name.
- **Docker networking enables connectivity, but application code initiates communication.**
- `--network` connects containers to the same network.
- `-e` sets environment variables inside containers.
- `-p` publishes container ports to the host; it isn't required for internal container-to-container communication.
- `docker logs` and `docker ps` help verify and troubleshoot running containers.
- **Docker Compose** uses a `docker-compose.yml` (or `compose.yaml`) file to define and manage multiple containers, including their services, networks, ports and environment variables.
  - `docker compose up -d` — creates and starts all defined services in the background, building or pulling images when needed.
  - `docker compose down` — stops and removes the containers and networks created by Compose (but preserves named volumes by default).
