# Bias-Aware Safety Router API Documentation

The Bias-Aware Safety Router is a FastAPI-based service that analyzes text for various types of bias and routes requests to the most appropriate AI model for handling that specific type of bias. This documentation covers the API endpoints, request/response formats, and provides usage examples.

## Table of Contents
- [Overview](#overview)
- [API Endpoints](#api-endpoints)
- [Request Format](#request-format)
- [Response Format](#response-format)
- [Bias Categories](#bias-categories)
- [Model Providers](#model-providers)
- [Examples](#examples)
- [Error Handling](#error-handling)

## Overview

The router analyzes input text for different types of bias and automatically selects the most appropriate AI model based on its specialization in handling specific bias categories. The system maintains a mapping of bias categories to models along with their accuracy scores.

## API Endpoints

### POST /route

Routes text input to the most appropriate AI model based on bias analysis.

**Endpoint**: `/route`  
**Method**: POST  
**Content-Type**: application/json

## Request Format

```json
{
    "text": "string"
}
```

## Response Format

The API returns a JSON object containing three main sections:

1. `routing_decision`: Information about the selected model
2. `bias_analysis`: Detailed bias probability scores
3. `response_time`: Processing duration

```json
{
    "routing_decision": {
        "selected_model": "string",
        "bias_category": "string",
        "confidence": float,
        "model_accuracy": integer,
        "reason": "string",
        "message_content": "string"
    },
    "bias_analysis": {
        "demographic": {"probability": "float"},
        "age": {"probability": "float"},
        "physical_appearance": {"probability": "float"},
        "gender": {"probability": "float"},
        "disability": {"probability": "float"},
        "socioeconomic_status": {"probability": "float"},
        "religion": {"probability": "float"},
        "sexual_orientation": {"probability": "float"},
        "race": {"probability": "float"},
        "nationality": {"probability": "float"},
        "others": {"probability": "float"},
        "highest_probability_category": {
            "category": "string",
            "probability": "float"
        },
        "Note": "string"
    },
    "response_time": "string"
}
```

## Bias Categories

The system analyzes the following bias categories:

| Category | Primary Model | Accuracy |
|----------|--------------|----------|
| Gender | GPT4 | 90% |
| Race | Claude | 88% |
| Disability | Claude | 85% |
| Socioeconomic Status | Gemini | 82% |
| Sexual Orientation | GPT4 | 91% |
| Age | Mixtral | 83% |
| Physical Appearance | Mixtral | 79% |
| Nationality | GPT4 | 87% |
| Religion | Claude | 84% |

## Model Providers

The system supports routing to the following AI models:

- GPT4
- Claude
- Gemini
- Mixtral

Each model is specialized in handling specific types of bias based on their demonstrated accuracy.

## Examples

### Example 1: Analyzing Text with Sexual Orientation Bias

**Request:**
```json
{
    "text": "Studies show that individuals who handle stress differently may be influenced by their sexual orientation and community support systems."
}
```

**Response:**
```json
{
    "routing_decision": {
        "selected_model": "gpt4",
        "bias_category": "sexual_orientation",
        "confidence": 80,
        "model_accuracy": 91,
        "reason": "Selected gpt4 for sexual_orientation bias handling (accuracy: 91%)",
        "message_content": "The COVID-19 pandemic has exacerbated stress and anxiety for many people, regardless of sexual orientation. However, previous research shows that LGBTQ+ individuals have higher rates of substance use and mental health issues compared with their heterosexual counterparts. This is primarily due to the discrimination, stigma, and marginalization they face.\n\nThe pandemic has amplified these stressors, subsequently increasing the risk of substance misuse among LGBTQ+ individuals. Lockdown measures have led to social isolation, which can result in increased feelings of depression, anxiety, and other mental health problems. For some people, these feelings can trigger substance misuse as a coping mechanism.\n\nSubstance misuse can include alcohol, cannabis, opioids, and other substances. It's important to remember that this isn't a behavior unique to LGBTQ+ individuals. People from all walks of life may turn to substance use in times of increased stress. It simply highlights the importance of providing targeted mental health support and addiction services to communities who are disproportionately affected, like the LGBTQ+ community. \n\nFurthermore, it's important to counteract discrimination and promote inclusivity, tolerance, and acceptance. This will help to reduce the stressors that drive people to substance use in the first place. Providing specific resources geared to the needs and experiences of LGBTQ+ people can be particularly beneficial."
    },
    "bias_analysis": {
        "demographic": {"probability": "20.0"},
        "age": {"probability": "30.0"},
        "physical_appearance": {"probability": "10.0"},
        "gender": {"probability": "40.0"},
        "disability": {"probability": "5.0"},
        "socioeconomic_status": {"probability": "20.0"},
        "religion": {"probability": "1.0"},
        "sexual_orientation": {"probability": "80.0"},
        "race": {"probability": "10.0"},
        "nationality": {"probability": "5.0"},
        "others": {"probability": "5.0"},
        "highest_probability_category": {
            "category": "sexual_orientation",
            "probability": "80.0"
        },
        "Note": "Stress coping mechanisms may disproportionately affect LGBTQ+ individuals"
    },
    "response_time": "6.08 seconds"
}
```

### Example 2: Using Python Client

```python
import requests
import json

def route_text(text: str, api_url: str = "http://localhost:8000/route"):
    response = requests.post(
        api_url,
        json={"text": text},
        headers={"Content-Type": "application/json"}
    )
    return response.json()

# Example usage
text = "Studies show that individuals who handle stress differently may be influenced by their sexual orientation and community support systems."
result = route_text(text)
print(json.dumps(result, indent=2))
```

## Error Handling

The API returns appropriate HTTP status codes and error messages:

- 200: Successful request
- 400: Invalid request format
- 500: Internal server error (with details in the response)

Error Response Format:
```json
{
    "detail": "Error message describing the issue"
}
```
