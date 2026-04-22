# DFU Backend Vercel Deployment Guide

## Overview

Your FastAPI backend is configured for **Vercel Serverless Functions**. This approach is better than Flask for Vercel because:
- ✅ FastAPI: Async, type hints, auto OpenAPI docs, better performance
- ✅ Serverless: Each endpoint is a function, scales independently
- ✅ No long-running processes: Vercel timeouts kill sustained connections
- ⚠️ Limitations: 12-second cold-start timeout (watch cold starts), 3GB RAM max per function

---

## Configuration Files

### `vercel.json` - Routing & Builds
```json
{
  "version": 2,
  "builds": [
    {
      "src": "api/*.py",
      "use": "@vercel/python"
    }
  ],
  "routes": [
    {
      "src": "/health",
      "dest": "api/health.py"
    },
    {
      "src": "/predict",
      "dest": "api/predict.py"
    },
    {
      "src": "/chat",
      "dest": "api/chat.py"
    }
  ]
}
```
- Builds all Python files in `api/` folder
- Routes requests to respective handler functions

### `.vercelignore`
Excludes heavy files (datasets, venv, build) from deployment to reduce size.

### `requirements.txt` - Optimized for Vercel
- Changed `opencv-python` → `opencv-python-headless` (no GUI libraries, lighter)
- Removed `matplotlib`, `seaborn` (not used in API, save ~500MB)
- Pinned versions for reproducibility

---

## Serverless Function Structure

Each endpoint is a Python file in `/api/` with a `handler` class:

```python
from http.server import BaseHTTPRequestHandler
import json

class handler(BaseHTTPRequestHandler):
    def do_GET(self):
        # Handle GET request
        self.send_response(200)
        self.send_header('Content-Type', 'application/json')
        self.end_headers()
        self.wfile.write(json.dumps({"status": "ok"}).encode())
    
    def do_POST(self):
        # Handle POST request
        pass
    
    def do_OPTIONS(self):
        # Handle CORS preflight
        pass
```

---

## Endpoints

### 1. **GET /health** → `api/health.py`
Health check endpoint.

**Request:**
```bash
curl https://your-project.vercel.app/health
```

**Response:**
```json
{
  "status": "healthy",
  "service": "DFU Screening API",
  "version": "2.0.0",
  "timestamp": "2026-04-22T12:34:56Z"
}
```

---

### 2. **POST /predict** → `api/predict.py`
Core DFU prediction endpoint.

**Note:** Vercel serverless has strict binary limits. Instead of multipart form upload, send **base64-encoded image** in JSON.

**Request:**
```bash
# Encode image to base64
import base64
with open("image.jpg", "rb") as f:
    image_b64 = base64.b64encode(f.read()).decode()

# Send to API
curl -X POST https://your-project.vercel.app/predict \
  -H "Content-Type: application/json" \
  -d "{\"image\": \"$image_b64\"}"
```

**Response:**
```json
{
  "success": true,
  "prediction": {
    "stage": 1,
    "label": "Grade 3 - Osteomyelitis",
    "confidence": "0.9234",
    "wagner_scale": "Grade 3",
    "probabilities": {
      "Grade 0 - Healthy": 0.001,
      "Grade 3 - Osteomyelitis": 0.9234,
      ...
    }
  },
  "clinical_report": "...",
  "ai_insights": "...",
  "metadata": {
    "model": "MobileNetV3-Small (Trained)",
    "timestamp": "..."
  }
}
```

**Troubleshooting:**
- **Cold start timeout (>12s)**: Model loading takes time. First request slow, subsequent fast.
- **Base64 too large**: Compress image before encoding (`PIL.Image.thumbnail((512, 512))`).

---

### 3. **POST /chat** → `api/chat.py`
Chat with Groq AI assistant.

**Request:**
```bash
curl -X POST https://your-project.vercel.app/chat \
  -H "Content-Type: application/json" \
  -d "{\"message\": \"What does Grade 3 mean?\"}"
```

**Response:**
```json
{
  "success": true,
  "message": "What does Grade 3 mean?",
  "response": "Grade 3 represents osteomyelitis, where the ulcer has penetrated to bone..."
}
```

---

## Step-by-Step Deployment

### **Step 1: Install Vercel CLI**
```bash
npm install -g vercel
```

### **Step 2: Authenticate**
```bash
vercel login
```
You'll be redirected to browser to sign in (or create) Vercel account.

### **Step 3: Deploy**
```bash
cd dfu_backend
vercel --prod
```

**Deployment will:**
1. Build Python environment using `@vercel/python`
2. Install `requirements.txt` dependencies
3. Deploy serverless functions from `api/` folder
4. Assign domain: `your-project.vercel.app`

### **Step 4: Set Environment Variables** (if needed)
If your code uses `.env` files (e.g., `GROQ_API_KEY`):

```bash
vercel env add GROQ_API_KEY <your-key>
vercel --prod
```

Or in Vercel Dashboard:
1. Go to **Settings** → **Environment Variables**
2. Add `GROQ_API_KEY=<your-key>`
3. Redeploy

### **Step 5: Test Deployed API**
```bash
# Health check
curl https://your-project.vercel.app/health

# Predict (with base64 image)
curl -X POST https://your-project.vercel.app/predict \
  -H "Content-Type: application/json" \
  -d "{\"image\": \"<base64-data>\"}"
```

---

## Performance Tips

### Cold Start Optimization
1. **Import only what you need** in each function (not all agents upfront)
2. **Use layers**: Move shared code to separate files
3. **Pre-warm**: Set up Vercel cron job to ping `/health` every 5 min

### Deployment Size
Current size estimate:
- `torch` + `torchvision`: ~500MB (largest)
- `opencv-python-headless`: ~180MB
- Other deps: ~50MB
- **Total: ~730MB** (within Vercel's 250MB uncompressed limit with gzip)

If size exceeds limits:
1. Remove unused imports
2. Use Docker-based deployment instead (Vercel also supports `Dockerfile`)
3. Split model loading into separate function

---

## Common Issues

| Problem | Solution |
|---------|----------|
| **502 Bad Gateway** | Check logs: `vercel logs`. Usually cold-start timeout. |
| **413 Payload Too Large** | Image too big. Compress/reduce resolution before encoding. |
| **ModuleNotFoundError** | Missing dependency in `requirements.txt`. Add and redeploy. |
| **CORS errors** | Endpoints have `do_OPTIONS()` handlers. Check frontend URL in `ALLOWED_ORIGINS`. |
| **GROQ_API_KEY not found** | Set env var: `vercel env add GROQ_API_KEY <key>` |

---

## File Structure After Setup

```
dfu_backend/
├── api/
│   ├── health.py        ← GET /health
│   ├── predict.py       ← POST /predict
│   └── chat.py          ← POST /chat
├── agents/              ← Existing agents
├── models/              ← Model weights (must exist locally)
├── main.py              ← Local dev server (not deployed)
├── vercel.json          ← Vercel config
├── .vercelignore        ← Exclude from deployment
├── requirements.txt     ← Python dependencies
└── README.md
```

---

## Next Steps

1. ✅ **Deploy**: `vercel --prod`
2. ✅ **Update Frontend**: Change API base URL from `localhost:8000` to `https://your-project.vercel.app`
3. ✅ **Monitor**: Use Vercel Dashboard → Deployments → Logs
4. ✅ **Scale**: Vercel auto-scales; no server management needed

---

## FastAPI vs Flask Decision

You've chosen **FastAPI** ✅ — correct for Vercel:
- Async handlers → better resource usage
- Type validation → fewer runtime errors
- Auto OpenAPI docs → `/docs` endpoint
- Smaller startup time → faster cold starts

Flask would work but slower startup = longer cold-start penalty on Vercel.

---

## Support

- **Vercel Docs**: https://vercel.com/docs/functions/python
- **FastAPI Docs**: https://fastapi.tiangolo.com/
- **Debug locally first**: `uvicorn main:app --reload` before deploying
