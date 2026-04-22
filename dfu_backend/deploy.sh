#!/bin/bash

# Vercel Deployment Script for DFU Backend
# Usage: ./deploy.sh [--prod]

set -e

echo "🚀 DFU Backend Vercel Deployment Script"
echo "========================================"

# Check if Vercel CLI is installed
if ! command -v vercel &> /dev/null; then
    echo "❌ Vercel CLI not found. Install it:"
    echo "   npm install -g vercel"
    exit 1
fi

# Check if in correct directory
if [ ! -f "vercel.json" ]; then
    echo "❌ vercel.json not found. Run this script from dfu_backend/ folder."
    exit 1
fi

echo "✅ Vercel CLI detected"
echo "📦 Checking Python environment..."

# List API functions
echo ""
echo "📋 API Functions to Deploy:"
for file in api/*.py; do
    if [ -f "$file" ] && [ "$(basename "$file")" != "__init__.py" ]; then
        echo "   - $(basename "$file")"
    fi
done

echo ""
echo "📝 Deployment Settings:"
echo "   - Python version: 3.11+"
echo "   - Serverless timeout: 12 seconds (cold start)"
echo "   - Build: api/*.py"
echo ""

# Check for environment variables
if [ -f ".env" ]; then
    echo "⚠️  Local .env found. Add secrets to Vercel Dashboard:"
    echo "   vercel env add <VAR_NAME> <value>"
fi

echo ""

# Determine production vs preview
if [ "$1" = "--prod" ]; then
    echo "🌍 Deploying to PRODUCTION..."
    vercel --prod
else
    echo "🧪 Deploying to PREVIEW..."
    echo "   (Use './deploy.sh --prod' for production)"
    vercel
fi

echo ""
echo "✅ Deployment Complete!"
echo "   Visit: https://your-project.vercel.app"
echo ""
echo "📚 Documentation: see VERCEL_DEPLOYMENT.md"
