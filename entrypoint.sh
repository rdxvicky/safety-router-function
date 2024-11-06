#!/bin/bash
ollama pull llama3.2
exec uvicorn app.main:app --host 0.0.0.0 --port 80
