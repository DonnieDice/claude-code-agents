# Image Generation Tool Setup Script for Windows
# This script sets up the image generation tool for Claude Code

Write-Host "Setting up Image Generation Tool for Claude Code..." -ForegroundColor Cyan

# Check Python installation
if (-not (Get-Command python -ErrorAction SilentlyContinue)) {
    Write-Host "Python is not installed. Please install Python 3.8+ first." -ForegroundColor Red
    exit 1
}

# Install required Python packages
Write-Host "Installing Python dependencies..." -ForegroundColor Yellow
pip install requests urllib3

# Create output directory
$outputDir = Join-Path $PSScriptRoot "generated_images"
if (-not (Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir | Out-Null
    Write-Host "Created output directory: $outputDir" -ForegroundColor Green
}

# Create environment file template
$envFile = Join-Path $PSScriptRoot ".env"
if (-not (Test-Path $envFile)) {
    @"
# Image Generation API Keys
# Uncomment and add your API keys to enable additional providers

# TOGETHER_API_KEY=your_together_api_key
# DEEPAI_API_KEY=your_deepai_api_key
# STABILITY_API_KEY=your_stability_api_key
# OPENAI_API_KEY=your_openai_api_key
# REPLICATE_API_TOKEN=your_replicate_token
# HUGGINGFACE_API_KEY=your_huggingface_key
# GETIMG_API_KEY=your_getimg_key
# LEONARDO_API_KEY=your_leonardo_key
"@ | Out-File -FilePath $envFile -Encoding UTF8
    Write-Host "Created .env file template: $envFile" -ForegroundColor Green
}

# Create batch file for easy execution
$batchFile = Join-Path $PSScriptRoot "generate.bat"
@"
@echo off
python "%~dp0image_generator.py" %*
"@ | Out-File -FilePath $batchFile -Encoding ASCII
Write-Host "Created batch file: $batchFile" -ForegroundColor Green

# Test the installation
Write-Host "`nTesting installation with free provider..." -ForegroundColor Yellow
python (Join-Path $PSScriptRoot "image_generator.py") "test image: a beautiful sunset" pollinations

if ($LASTEXITCODE -eq 0) {
    Write-Host "`nSetup completed successfully!" -ForegroundColor Green
    Write-Host "You can now generate images using:" -ForegroundColor Cyan
    Write-Host "  .\generate.bat 'your prompt here'" -ForegroundColor White
    Write-Host "  python image_generator.py 'your prompt' [provider] [size]" -ForegroundColor White
} else {
    Write-Host "`nSetup completed but test failed. Please check the installation." -ForegroundColor Yellow
}

Write-Host "`nAvailable providers:" -ForegroundColor Cyan
Write-Host "  - pollinations (FREE, no API key required)" -ForegroundColor Green
Write-Host "  - together (requires API key)" -ForegroundColor Yellow
Write-Host "  - deepai (requires API key)" -ForegroundColor Yellow
Write-Host "  - stability (requires API key)" -ForegroundColor Yellow
Write-Host "  - openai (requires API key)" -ForegroundColor Yellow
Write-Host "  - replicate (requires API key)" -ForegroundColor Yellow
Write-Host "  - huggingface (requires API key)" -ForegroundColor Yellow
Write-Host "  - getimg (requires API key)" -ForegroundColor Yellow
Write-Host "  - leonardo (requires API key)" -ForegroundColor Yellow

Write-Host "`nTo enable additional providers, add API keys to the .env file" -ForegroundColor Cyan