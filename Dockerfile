# Use the official Ollama image as base
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Copy requirements first to leverage Docker cache
COPY requirements.txt /app/

RUN pip install -no-cache-dir -r requirements.txt

# Copy the rest of the application
COPY app /app

CMD ["ollama", "pull", "llama3.2"]

EXPOSE 80

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "80"]
