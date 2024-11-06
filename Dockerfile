# Use the official Python image as base
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install system dependencies required for Ollama
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install Ollama using the official installation script
RUN curl -fsSL https://ollama.com/install.sh | sh

# Copy requirements first to leverage Docker cache
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application
COPY . /app/

# Start Ollama service, pull the model, and then shutdown the service
RUN service ollama start && \
    sleep 5 && \
    ollama pull llama3.2 && \
    service ollama stop

# Expose port for FastAPI
EXPOSE 80

# Start Ollama service and then run the FastAPI app
CMD ["sh", "-c", "service ollama start && uvicorn app.main:app --host 0.0.0.0 --port 80"]
