# Use the official Ollama Docker image as the base
FROM ghcr.io/ollama/ollama:latest

# Set the working directory
WORKDIR /app

# Copy the application code into the container
COPY . /app

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Pull the Llama 3.2 model
RUN ollama pull llama3.2

# Expose the port your FastAPI app will run on
EXPOSE 80

# Start the FastAPI application
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "80"]
