# Deepseek Code Assistant PowerShell Wrapper
# Specialized for code generation and technical tasks

param(
    [Parameter(Mandatory=$true, Position=0)]
    [string]$Prompt,
    
    [Parameter(Mandatory=$false)]
    [ValidateSet("coder", "chat")]
    [string]$Mode = "coder",
    
    [Parameter(Mandatory=$false)]
    [string]$Context = "",
    
    [Parameter(Mandatory=$false)]
    [int]$MaxTokens = 1000,
    
    [Parameter(Mandatory=$false)]
    [switch]$Optimize,
    
    [Parameter(Mandatory=$false)]
    [switch]$DebugMode
)

# Check if router is running
$routerStatus = & ccr status 2>&1
if ($routerStatus -like "*Not Running*") {
    Write-Host "Starting Claude Code Router..." -ForegroundColor Yellow
    Start-Process -FilePath "ccr" -ArgumentList "start" -NoNewWindow
    Start-Sleep -Seconds 2
}

# Select model based on mode
$Model = if ($Mode -eq "coder") { "deepseek-coder" } else { "deepseek-chat" }

# Set context based on task
if (-not $Context) {
    if ($Mode -eq "coder") {
        $Context = "You are DeepSeek Coder, an expert programming assistant. Generate clean, efficient, well-documented code with best practices."
    } else {
        $Context = "You are DeepSeek Chat, a helpful AI assistant specializing in technical discussions and problem-solving."
    }
}

# Add optimization instructions
if ($Optimize) {
    $Context += " Focus on performance optimization, efficiency, and scalability."
}

# Add debug instructions
if ($DebugMode) {
    $Context += " Include detailed debugging information, error handling, and logging."
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
    model = "deepseek,$Model"
    messages = $messages
    max_tokens = $MaxTokens
    temperature = 0.7
} | ConvertTo-Json -Depth 10

try {
    Write-Host "Sending request to Deepseek $Mode..." -ForegroundColor Cyan
    
    $response = Invoke-RestMethod -Uri "http://127.0.0.1:3456/v1/messages" `
        -Method Post `
        -ContentType "application/json" `
        -Body $body `
        -ErrorAction Stop
    
    if ($response.content) {
        Write-Host "`n=== Deepseek Response ===" -ForegroundColor Magenta
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
    Write-Host "`nDeepseek Assistant Usage Examples:" -ForegroundColor Cyan
    Write-Host "===================================" -ForegroundColor Cyan
    Write-Host "`nCode Generation (default):"
    Write-Host '  .\deepseek-assist.ps1 "Create a Python web scraper"'
    Write-Host '  .\deepseek-assist.ps1 "Write a React component"'
    Write-Host "`nChat Mode:"
    Write-Host '  .\deepseek-assist.ps1 "Explain TCP vs UDP" -Mode chat'
    Write-Host "`nOptimization:"
    Write-Host '  .\deepseek-assist.ps1 "Optimize this SQL query" -Optimize'
    Write-Host "`nDebug Mode:"
    Write-Host '  .\deepseek-assist.ps1 "Debug this error" -DebugMode'
}