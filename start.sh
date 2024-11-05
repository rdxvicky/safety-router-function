#!/bin/bash
set -e

# Start ollama serve in the background
ollama serve &

# Wait for Ollama to be ready
echo "Waiting for Ollama to start..."
until curl -s http://localhost:11434/api/tags >/dev/null; do
    sleep 1
done
echo "Ollama is ready"

# Pull the required model
echo "Pulling llama3.2 model..."
ollama pull llama3.2

# Start the FastAPI application
echo "Starting FastAPI application..."
exec uvicorn app.main:app --host 0.0.0.0 --port 80
