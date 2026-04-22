# Vercel Deployment Script for DFU Backend (Windows)
# Usage: .\deploy.ps1 [-Prod]

param(
    [switch]$Prod
)

Write-Host "🚀 DFU Backend Vercel Deployment Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if Vercel CLI is installed
try {
    $vercelVersion = & vercel --version 2>$null
    Write-Host "✅ Vercel CLI detected: $vercelVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Vercel CLI not found. Install it:" -ForegroundColor Red
    Write-Host "   npm install -g vercel" -ForegroundColor Yellow
    exit 1
}

# Check if in correct directory
if (-not (Test-Path "vercel.json")) {
    Write-Host "❌ vercel.json not found. Run from dfu_backend\ folder." -ForegroundColor Red
    exit 1
}

Write-Host "📦 Checking Python environment..."
Write-Host ""

# List API functions
Write-Host "📋 API Functions to Deploy:" -ForegroundColor Yellow
Get-ChildItem "api\*.py" -Exclude "__init__.py" | ForEach-Object {
    Write-Host "   - $($_.Name)" -ForegroundColor Gray
}

Write-Host ""
Write-Host "📝 Deployment Settings:" -ForegroundColor Yellow
Write-Host "   - Python version: 3.11+"
Write-Host "   - Serverless timeout: 12 seconds (cold start)"
Write-Host "   - Build: api\*.py"
Write-Host ""

# Check for environment variables
if (Test-Path ".env") {
    Write-Host "⚠️  Local .env found. Add secrets to Vercel Dashboard:" -ForegroundColor Yellow
    Write-Host "   vercel env add GROQ_API_KEY <your-key>" -ForegroundColor Gray
}

Write-Host ""

# Deploy
if ($Prod) {
    Write-Host "🌍 Deploying to PRODUCTION..." -ForegroundColor Cyan
    & vercel --prod
} else {
    Write-Host "🧪 Deploying to PREVIEW..." -ForegroundColor Cyan
    Write-Host "   (Use '.\deploy.ps1 -Prod' for production)" -ForegroundColor Gray
    & vercel
}

Write-Host ""
Write-Host "✅ Deployment Complete!" -ForegroundColor Green
Write-Host "   Check: https://your-project.vercel.app/health" -ForegroundColor Gray
Write-Host "   Docs: see VERCEL_DEPLOYMENT.md" -ForegroundColor Gray
