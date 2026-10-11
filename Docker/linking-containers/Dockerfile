FROM python:3.8-slim
WORKDIR /app

# Install Linux dependencies required by mysqlclient
RUN apt-get update && apt-get install -y \
    build-essential \
    pkg-config \
    default-libmysqlclient-dev \
    && rm -rf /var/lib/apt/lists/*

COPY . .
RUN pip install flask mysqlclient
EXPOSE 5002
CMD ["python", "app.py"]
