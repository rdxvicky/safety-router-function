#!/bin/bash
# Start ollama serve in the background
ollama serve

# Pull the required model (you might need to add logic if it’s conditional)
ollama pull llama3.2

# Start the FastAPI application with uvicorn
uvicorn app.main:app --host 0.0.0.0 --port 80
