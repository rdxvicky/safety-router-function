# Use the official Python image as base
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install system dependencies required for Ollama
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install Ollama binary
RUN curl -L https://ollama.com/download/ollama-linux-amd64 -o /usr/local/bin/ollama \
    && chmod +x /usr/local/bin/ollama

# Copy requirements first to leverage Docker cache
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application
COPY . /app/

# Start Ollama service, pull the model, and then shutdown the service
RUN ollama serve & \
    sleep 5 && \
    ollama pull llama3.2 && \
    pkill ollama

# Expose port for FastAPI
EXPOSE 80

# Start Ollama service and then run the FastAPI app
CMD ["sh", "-c", "ollama serve & uvicorn app.main:app --host 0.0.0.0 --port 80"]
