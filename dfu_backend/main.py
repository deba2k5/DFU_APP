from fastapi import FastAPI, UploadFile, File, Form, HTTPException
from fastapi.responses import StreamingResponse
from fastapi.middleware.cors import CORSMiddleware
import uvicorn
import time
from agents.preprocessor import preprocessor_agent
from agents.diagnostician import diagnostician_agent
from agents.reporter import reporting_agent
from agents.assistant import assistant_agent


app = FastAPI(
    title="DFU Screening Platform API",
    description="Agentic pathway for AI-powered Diabetic Foot Ulcer detection.",
    version="1.0.0"
)

# Enable CORS for Flutter mobile app
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
async def root():
    return {
        "status": "online",
        "service": "DFU Backend",
        "version": "1.0.0",
        "agents": ["Preprocessor", "Diagnostician", "Reporter", "Assistant"]
    }

@app.post("/chat")
async def chat_with_assistant(message: str = Form(...)):
    """
    Streams raw LLM tokens back to the frontend using Server-Sent Events or chunked transfer.
    Expects a multipart form value `message`.
    """
    try:
        def stream_generator():
            for chunk in assistant_agent.chat_stream(message):
                yield chunk

        return StreamingResponse(stream_generator(), media_type="text/plain")
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/predict")
async def predict_ulcer(file: UploadFile = File(...)):
    """
    Executes the Agentic AI Pathway:
    1. Preprocessor: Normalizes the clinical image.
    2. Diagnostician: Classifies severity via DenseNet wrapper.
    3. Reporting: Synthesizes medical recommendations.
    """
    try:
        # Read file
        contents = await file.read()
        
        start_time = time.time()
        
        # 1. Pipeline Stage: Preprocessing
        processed_img = preprocessor_agent.process(contents)
        
        # 2. Pipeline Stage: Diagnosis
        diagnosis = diagnostician_agent.infer(processed_img)
        
        # 3. Pipeline Stage: Reporting (Enhanced with Groq Llama-4)
        base_report = reporting_agent.generate_summary(diagnosis)
        ai_clinical_summary = assistant_agent.get_summary(str(diagnosis))
        
        latency = time.time() - start_time
        
        return {
            "success": True,
            "prediction": diagnosis,
            "clinical_report": base_report,
            "ai_insights": ai_clinical_summary,
            "metadata": {
                "latency_ms": int(latency * 1000),
                "timestamp": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
            }
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
