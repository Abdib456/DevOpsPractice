FROM python:3.8-slim

# All subsequent commands are running in this work directory
WORKDIR /app

# Copying all the code into our app work dir
COPY . .

# Installing dependencies
RUN pip install flask

# Expose the port so its avaliable and we can access the container from our local host
# This makes the application accessible from outside the container
EXPOSE 5002

# Tells docker to run our python application(the app we want to run)
CMD ["python" , "app.py"]
