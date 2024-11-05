#!/bin/bash
set -e

# Start Ollama server in the background
echo "Starting Ollama server..."
ollama serve &

# Wait for Ollama to be ready (max 30 seconds)
echo "Waiting for Ollama to start..."
max_attempts=30
attempt=1
while ! curl -s http://localhost:11434/api/tags >/dev/null && [ $attempt -le $max_attempts ]; do
    echo "Attempt $attempt of $max_attempts: Waiting for Ollama server to be ready..."
    sleep 1
    attempt=$((attempt + 1))
done

if [ $attempt -gt $max_attempts ]; then
    echo "Warning: Ollama server did not respond within 30 seconds, but continuing startup..."
fi

# Start the FastAPI application
echo "Starting FastAPI application..."
exec uvicorn app.main:app --host 0.0.0.0 --port 80
