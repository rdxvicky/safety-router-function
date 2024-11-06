# Use the official Ollama image as base
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Copy requirements first to leverage Docker cache
COPY requirements.txt /app/

RUN pip install -no-cache-dir -r requirements.txt

# Copy the rest of the application
COPY entrypoint.sh /app/
RUN chmod +x /app/entrypoint.sh

EXPOSE 80

CMD ["/app/entrypoint.sh"]
