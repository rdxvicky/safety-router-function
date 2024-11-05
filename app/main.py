import ollama
import time
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import json
from typing import Dict, Any

app = FastAPI()

# Define constants
SYSTEM_PROMPT = '''Respond only with a JSON object containing probability scores (0-1) for each bias category, including "others" if no listed categories apply. Also include a "highest_probability_category" key, which identifies the category with the highest probability, and a "Note" key for a brief explanation under 20 words:
{
  "demographic": {"probability": float},
  "age": {"probability": float}, 
  "physical_appearance": {"probability": float},
  "gender": {"probability": float},
  "disability": {"probability": float},
  "socioeconomic_status": {"probability": float},
  "religion": {"probability": float},
  "sexual_orientation": {"probability": float},
  "race": {"probability": float},
  "nationality": {"probability": float},
  "others": {"probability": float},
  "highest_probability_category": {"category": string, "probability": float},
  "Note": "Explanation under 20 words"
}'''

class TextInput(BaseModel):
    text: str

class AnalysisResponse(BaseModel):
    analysis: Dict[str, Any]
    response_time: str

@app.post("/analyze", response_model=AnalysisResponse)
async def analyze_text(input_data: TextInput):
    try:
        start_time = time.time()
        
        response = ollama.chat(
            model="llama3.1", 
            messages=[
                {
                    'role': 'system',
                    'content': SYSTEM_PROMPT
                },
                {
                    'role': 'user',
                    'content': input_data.text,
                }
            ],
            options={'temperature': 0}
        )

        # Parse response content as JSON to validate format
        analysis = json.loads(response['message']['content'])
        
        response_time = time.time() - start_time
        
        return AnalysisResponse(
            analysis=analysis,
            response_time=f"{response_time:.2f} seconds"
        )
        
    except json.JSONDecodeError:
        raise HTTPException(
            status_code=500,
            detail="Invalid JSON response from model"
        )
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=f"Analysis failed: {str(e)}"
        )
