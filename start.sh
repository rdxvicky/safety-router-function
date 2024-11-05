#!/bin/bash
set -e

# Function to check if model is already pulled
check_model() {
    local model=$1
    ollama list | grep -q "$model"
    return $?
}

# Function to pull model with retry
pull_model() {
    local model=$1
    local max_attempts=3
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        echo "Attempt $attempt to pull $model..."
        
        if check_model "$model"; then
            echo "Model $model is already pulled"
            return 0
        fi
        
        # Try to pull the model
        if ollama pull "$model" ; then
            echo "Successfully pulled $model"
            return 0
        fi
        
        echo "Failed to pull model on attempt $attempt"
        attempt=$((attempt + 1))
        
        if [ $attempt -le $max_attempts ]; then
            echo "Waiting 30 seconds before retry..."
            sleep 30
        fi
    done
    
    echo "Failed to pull model after $max_attempts attempts"
    return 1
}

# Start ollama serve in the background
echo "Starting Ollama server..."
ollama serve &

# Wait for Ollama to be ready
echo "Waiting for Ollama to start..."
max_wait=60
wait_count=0
until curl -s http://localhost:11434/api/tags >/dev/null || [ $wait_count -eq $max_wait ]; do
    sleep 1
    wait_count=$((wait_count + 1))
done

if [ $wait_count -eq $max_wait ]; then
    echo "Timeout waiting for Ollama to start"
    exit 1
fi

echo "Ollama is ready"

# Try to pull the model
MODEL_NAME="mistral"  # Using mistral instead of llama3.2 as it's more stable
if ! pull_model "$MODEL_NAME"; then
    echo "Failed to pull model, but continuing with server startup..."
fi

# Start the FastAPI application
echo "Starting FastAPI application..."
exec uvicorn app.main:app --host 0.0.0.0 --port 80
