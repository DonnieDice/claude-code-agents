# Gemini AI Assistant PowerShell Wrapper
# Google's Gemini models for versatile AI assistance

param(
    [Parameter(Mandatory=$true, Position=0)]
    [string]$Prompt,
    
    [Parameter(Mandatory=$false)]
    [ValidateSet("pro", "flash", "1.5-pro")]
    [string]$Model = "flash",
    
    [Parameter(Mandatory=$false)]
    [string]$Context = "",
    
    [Parameter(Mandatory=$false)]
    [int]$MaxTokens = 1000,
    
    [Parameter(Mandatory=$false)]
    [switch]$Vision,
    
    [Parameter(Mandatory=$false)]
    [switch]$Detailed
)

# Check if router is running
$routerStatus = & ccr status 2>&1
if ($routerStatus -like "*Not Running*") {
    Write-Host "Starting Claude Code Router..." -ForegroundColor Yellow
    Start-Process -FilePath "ccr" -ArgumentList "start" -NoNewWindow
    Start-Sleep -Seconds 2
}

# Select Gemini model
$GeminiModel = switch($Model) {
    "pro" { "gemini-1.5-pro-latest" }
    "flash" { "gemini-1.5-flash-latest" }
    "1.5-pro" { "gemini-1.5-pro-latest" }
    default { "gemini-1.5-flash-latest" }
}

# Set context based on task
if (-not $Context) {
    $Context = "You are Google Gemini, an advanced AI assistant. Provide helpful, accurate, and well-structured responses."
}

# Add vision context if specified
if ($Vision) {
    $Context += " Analyze and describe visual content when provided. Be detailed and accurate in your descriptions."
}

# Add detailed mode
if ($Detailed) {
    $Context += " Provide comprehensive, detailed explanations with examples when appropriate."
}

# Build the request
$messages = @(
    @{
        role = "system"
        content = $Context
    },
    @{
        role = "user"
        content = $Prompt
    }
)

$body = @{
    model = "gemini,$GeminiModel"
    messages = $messages
    max_tokens = $MaxTokens
    temperature = 0.7
} | ConvertTo-Json -Depth 10

try {
    Write-Host "Sending request to Gemini $Model..." -ForegroundColor Blue
    
    $response = Invoke-RestMethod -Uri "http://127.0.0.1:3456/v1/messages" `
        -Method Post `
        -ContentType "application/json" `
        -Body $body `
        -ErrorAction Stop
    
    if ($response.content) {
        Write-Host "`n=== Gemini Response ===" -ForegroundColor Blue
        Write-Host $response.content[0].text
        
        # Copy to clipboard
        $response.content[0].text | Set-Clipboard
        Write-Host "`nResponse copied to clipboard" -ForegroundColor Gray
        
        # Show token usage if available
        if ($response.usage) {
            Write-Host "Tokens used: $($response.usage.total_tokens)" -ForegroundColor Gray
        }
    }
    else {
        Write-Host "No response received" -ForegroundColor Red
    }
}
catch {
    Write-Host "Error: $_" -ForegroundColor Red
    Write-Host "Make sure Claude Code Router is running (ccr start)" -ForegroundColor Yellow
}

# Help text
if ($Prompt -eq "--help" -or $Prompt -eq "-h") {
    Write-Host "`nGemini Assistant Usage Examples:" -ForegroundColor Blue
    Write-Host "=================================" -ForegroundColor Blue
    Write-Host "`nQuick answers (Flash model - default):"
    Write-Host '  .\gemini-assist.ps1 "Explain quantum computing"'
    Write-Host '  .\gemini-assist.ps1 "What is machine learning?"'
    Write-Host "`nPro model for complex tasks:"
    Write-Host '  .\gemini-assist.ps1 "Design a microservices architecture" -Model pro'
    Write-Host "`nDetailed explanations:"
    Write-Host '  .\gemini-assist.ps1 "How does blockchain work?" -Detailed'
    Write-Host "`nVision tasks (if supported):"
    Write-Host '  .\gemini-assist.ps1 "Analyze this image" -Vision'
    Write-Host "`nCustom context:"
    Write-Host '  .\gemini-assist.ps1 "Review this code" -Context "You are a code reviewer"'
}