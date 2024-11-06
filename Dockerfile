# Use the official Python image as base
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install system dependencies required for Ollama and pkill
RUN apt-get update && apt-get install -y \
    curl \
    procps \
    && rm -rf /var/lib/apt/lists/*

# Install Ollama using the official installation script
RUN curl -fsSL https://ollama.com/install.sh | sh

# Copy requirements first to leverage Docker cache
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application
COPY . /app/

# Start Ollama process, pull the model, and then terminate the process
RUN ollama serve & \
    sleep 5 && \
    ollama pull llama3.2 && \
    pkill ollama

# Expose port for FastAPI
EXPOSE 80

# Start Ollama process and then run the FastAPI app
CMD ["sh", "-c", "ollama serve & uvicorn app.main:app --host 0.0.0.0 --port 80"]
