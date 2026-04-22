from fastapi import FastAPI, UploadFile, File, Form, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import StreamingResponse
import os
import time
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

from agents.preprocessor import preprocessor_agent
from agents.diagnostician import diagnostician_agent
from agents.reporter import reporting_agent
from agents.assistant import assistant_agent

app = FastAPI(
    title="DFU Screening Platform API",
    description="Agentic AI pathway for Diabetic Foot Ulcer detection — powered by Groq Llama-4.",
    version="2.0.0",
    docs_url="/docs",
    redoc_url="/redoc",
)

# CORS — allow all origins so Flutter web/mobile can connect
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
        "service": "DFU Screening API",
        "version": "2.0.0",
        "agents": ["Preprocessor", "Diagnostician", "Reporter", "Assistant"],
        "docs": "/docs",
    }


@app.get("/health")
async def health():
    return {"status": "healthy", "timestamp": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())}


@app.post("/predict")
async def predict_ulcer(file: UploadFile = File(...)):
    """
    Full Agentic AI Pipeline:
    1. Preprocessor — normalizes the clinical image (Pillow-based)
    2. Diagnostician — classifies DFU severity (Wagner Scale)
    3. Reporter — generates structured clinical guidelines
    4. Assistant — Groq Llama-4 AI insights summary
    """
    try:
        contents = await file.read()
        start_time = time.time()

        # Stage 1: Preprocess
        processed_img = preprocessor_agent.process(contents)

        # Stage 2: Diagnose
        diagnosis = diagnostician_agent.infer(processed_img)

        # Stage 3: Clinical report
        base_report = reporting_agent.generate_summary(diagnosis)

        # Stage 4: Groq AI summary
        ai_clinical_summary = assistant_agent.get_summary(str(diagnosis))

        latency = time.time() - start_time

        return {
            "success": True,
            "prediction": diagnosis,
            "clinical_report": base_report,
            "ai_insights": ai_clinical_summary,
            "metadata": {
                "latency_ms": int(latency * 1000),
                "model": "MobileNetV3-Small (Trained)",
                "timestamp": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
            },
        }

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Pipeline error: {str(e)}")


@app.post("/chat")
async def chat_with_assistant(message: str = Form(...)):
    """
    Streams real-time Groq Llama-4 tokens to the frontend.
    Uses chunked transfer encoding (SSE-compatible).
    """
    try:
        def stream_generator():
            for chunk in assistant_agent.chat_stream(message):
                yield chunk

        return StreamingResponse(stream_generator(), media_type="text/plain")

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
