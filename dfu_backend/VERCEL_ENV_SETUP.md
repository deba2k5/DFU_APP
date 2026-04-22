# Vercel Environment Variables Setup

## ⚠️ IMPORTANT: Your API Key is Now Protected

The `.env` file has been removed from git tracking. You must add environment variables directly to Vercel.

## Step 1: Set GROQ_API_KEY in Vercel Dashboard

1. Go to your **Vercel Project Dashboard**: https://vercel.com/dashboard
2. Select your **DFU_APP** project
3. Go to **Settings** → **Environment Variables**
4. Add a new variable:
   - **Name**: `GROQ_API_KEY`
   - **Value**: `gsk_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx` (copy from your local `.env` file)
   - **Environments**: Select `Production` and `Preview`
   - Click **Save**

## Step 2: Redeploy from Vercel

After adding the environment variable:
1. Go to **Deployments**
2. Click the "..." menu on the latest deployment
3. Select **Redeploy**

Or redeploy from CLI:
```bash
vercel --prod
```

## Step 3: Verify Deployment

Test your API endpoints:
```bash
curl https://your-project.vercel.app/health
```

Expected response:
```json
{
  "status": "healthy",
  "service": "DFU Screening API",
  "version": "2.0.0",
  "timestamp": "2026-04-22T..."
}
```

## Security Notes

✅ **Best Practices Applied:**
- `.env` file is now in `.gitignore`
- API key stored in Vercel's secure environment variables
- Never commit secrets to git
- Each environment (dev/prod) can have different keys

⚠️ **Do NOT:**
- Commit `.env` files to git
- Share API keys in code or documentation
- Hardcode secrets in source files
- Post API keys in issues or PRs

## Local Development

To use your API key locally:
1. Create a local `.env` file (git-ignored):
   ```
   GROQ_API_KEY=gsk_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
   ```
   (Replace with your actual key from Groq)

2. Load it in your app:
   ```python
   from dotenv import load_dotenv
   load_dotenv()
   api_key = os.getenv("GROQ_API_KEY")
   ```

3. Never commit this `.env` file

## Updated Vercel Configuration

Your `vercel.json` now uses the recommended `functions` configuration:
```json
{
  "functions": {
    "api/health.py": { "runtime": "python3.11" },
    "api/predict.py": { "runtime": "python3.11", "maxDuration": 60 },
    "api/chat.py": { "runtime": "python3.11" }
  }
}
```

This explicitly defines only the handler functions, preventing the `__init__.py` build error.

---

**Status**: ✅ Ready for production deployment with secure environment variables!

