# Use the official Ollama Docker image as the base
FROM ollama/ollama:latest

# Set the working directory
WORKDIR /app

# Copy the application code into the container
COPY . /app

# Set non-interactive mode to prevent timezone selection prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install Python and venv
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y python3.11 python3.11-venv && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Create and activate virtual environment
ENV VIRTUAL_ENV=/app/venv
RUN python3.11 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Install Python dependencies in virtual environment
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copy the startup script and make it executable
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Expose the port your FastAPI app will run on
EXPOSE 80

# Use the startup script as the CMD
CMD ["/start.sh"]
