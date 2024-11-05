# Dockerfile
FROM ollama/ollama:latest

# Set non-interactive mode
ENV DEBIAN_FRONTEND=noninteractive

# Set working directory
WORKDIR /app

# Install Python and dependencies
RUN apt-get update && \
    apt-get install -y software-properties-common curl && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y python3.11 python3.11-venv python3.11-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Create and activate virtual environment
ENV VIRTUAL_ENV=/app/venv
RUN python3.11 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Copy requirements first to leverage Docker cache
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application
COPY . .

# Make the startup script executable
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# Expose ports for both Ollama (11434) and FastAPI (80)
EXPOSE 11434 80

# Use ENTRYPOINT instead of CMD for the startup script
ENTRYPOINT ["/app/start.sh"]
