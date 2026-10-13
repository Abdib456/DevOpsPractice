# Stage 1: Build stage
FROM python:3.8-slim as Build

WORKDIR /app

RUN apt-get update && apt-get install -y \
    build-essential \
    pkg-config \
    default-libmysqlclient-dev \
    && rm -rf /var/lib/apt/lists/*

COPY . .

RUN pip install flask mysqlclient

# Stage 2: Production Stage

FROM python:3.8-slim

WORKDIR /app

# Copy installed Python packages (Flask, mysqlclient, etc.) from the build stage
COPY --from=Build /usr/local/lib/python3.8/site-packages /usr/local/lib/python3.8/site-packages

# Install the system library needed by mysqlclient to connect to MySQLibrary
RUN apt-get update && apt-get install -y \
libmariadb3 \
&& rm -rf /var/lib/apt/lists/*

# Copy application code
COPY --from=Build /app /app

EXPOSE 5002

CMD ["python", "app.py"]
