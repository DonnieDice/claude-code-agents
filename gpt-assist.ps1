# GPT Code Assistant PowerShell Wrapper
# Usage: .\gpt-assist.ps1 "Your code question here"

param(
    [Parameter(Mandatory=$true, Position=0)]
    [string]$Prompt,
    
    [Parameter(Mandatory=$false)]
    [string]$Model = "openai/gpt-3.5-turbo",
    
    [Parameter(Mandatory=$false)]
    [string]$Context = "",
    
    [Parameter(Mandatory=$false)]
    [int]$MaxTokens = 500,
    
    [Parameter(Mandatory=$false)]
    [switch]$CodeGeneration
)

# Check if router is running
$routerStatus = & ccr status 2>&1
if ($routerStatus -like "*Not Running*") {
    Write-Host "Starting Claude Code Router..." -ForegroundColor Yellow
    Start-Process -FilePath "ccr" -ArgumentList "start" -NoNewWindow
    Start-Sleep -Seconds 2
}

# Use GPT-4 for code generation tasks
if ($CodeGeneration) {
    $Model = "openai/gpt-4-turbo"
    if (-not $Context) {
        $Context = "You are an expert programmer. Generate clean, efficient, well-commented code."
    }
}

# Build the request
$messages = @()

if ($Context) {
    $messages += @{
        role = "system"
        content = $Context
    }
}

$messages += @{
    role = "user"
    content = $Prompt
}

$body = @{
    model = "openrouter,$Model"
    messages = $messages
    max_tokens = $MaxTokens
} | ConvertTo-Json -Depth 10

try {
    Write-Host "Sending request to GPT..." -ForegroundColor Cyan
    
    $response = Invoke-RestMethod -Uri "http://127.0.0.1:3456/v1/messages" `
        -Method Post `
        -ContentType "application/json" `
        -Body $body `
        -ErrorAction Stop
    
    if ($response.content) {
        Write-Host "`n=== GPT Response ===" -ForegroundColor Green
        Write-Host $response.content[0].text
        
        # Copy to clipboard
        $response.content[0].text | Set-Clipboard
        Write-Host "`n(Response copied to clipboard)" -ForegroundColor Gray
    }
    else {
        Write-Host "No response received" -ForegroundColor Red
    }
}
catch {
    Write-Host "Error: $_" -ForegroundColor Red
    Write-Host "Make sure Claude Code Router is running (ccr start)" -ForegroundColor Yellow
}

# Usage examples
if ($Prompt -eq "--help" -or $Prompt -eq "-h") {
    Write-Host @"

GPT Code Assistant Usage Examples:
==================================

Basic usage:
  .\gpt-assist.ps1 "Write a Python function to sort a list"

Code generation mode:
  .\gpt-assist.ps1 "Create a REST API in FastAPI" -CodeGeneration

With custom context:
  .\gpt-assist.ps1 "Explain this error" -Context "You are a debugging expert"

Using GPT-4:
  .\gpt-assist.ps1 "Complex algorithm question" -Model "openai/gpt-4-turbo"

Long response:
  .\gpt-assist.ps1 "Write complete documentation" -MaxTokens 2000

"@ -ForegroundColor Cyan
}