# Use the official Python 3.11 slim image as the base
FROM python:3.11-slim

# Set the working directory
WORKDIR /app

# Copy requirements and install packages
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code into the container
COPY . /app

# Expose port 80 for FastAPI app
EXPOSE 80

# Start FastAPI application
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "80"]
