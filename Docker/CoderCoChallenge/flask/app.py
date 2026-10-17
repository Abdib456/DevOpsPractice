from flask import Flask
import redis
import os

app = Flask(__name__)

@app.route('/')
def welcome_message():
    return 'Welcome to our Multi-Container application!'

@app.route('/count')
def redis_counter():
    r = redis.Redis(
        host=os.getenv("REDIS_HOST", 'redis'),
        port=int(os.getenv("REDIS_PORT", 6379))
    )
    count = str(r.incr("visits"))
    return f'This page has been visited {count} times.'

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5002)
