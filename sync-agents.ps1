# Claude Code Agents Sync Script
# This script syncs agents from the repository to project directories

param(
    [Parameter(Position=0)]
    [string]$Action = "list",
    
    [Parameter(Position=1)]
    [string]$AgentName = "",
    
    [Parameter(Position=2)]
    [string]$TargetPath = (Get-Location).Path
)

$AgentsRepo = $PSScriptRoot
$AgentsDir = Join-Path $AgentsRepo "agents"
$ConfigsDir = Join-Path $AgentsRepo "configs"

function Get-AvailableAgents {
    Write-Host "`n[AGENTS] Available Claude Code Agents:" -ForegroundColor Cyan
    Write-Host "=======================================" -ForegroundColor Cyan
    
    Get-ChildItem -Path $AgentsDir -Filter "*.md" | ForEach-Object {
        $name = $_.BaseName
        $content = Get-Content $_.FullName -First 10 -ErrorAction SilentlyContinue
        $description = ($content | Where-Object { $_ -match "^#" } | Select-Object -First 1) -replace "^#\s*", ""
        
        Write-Host "`n  >> $name" -ForegroundColor Green
        if ($description) {
            Write-Host "     $description" -ForegroundColor Gray
        }
    }
    Write-Host "`n"
}

function Deploy-Agent {
    param(
        [string]$Agent,
        [string]$Target
    )
    
    $agentFile = Join-Path $AgentsDir "$Agent.md"
    
    if (-not (Test-Path $agentFile)) {
        Write-Host "[ERROR] Agent '$Agent' not found!" -ForegroundColor Red
        Write-Host "Use 'sync-agents list' to see available agents" -ForegroundColor Yellow
        return
    }
    
    $targetClaudeFile = Join-Path $Target "CLAUDE.md"
    
    # Backup existing CLAUDE.md if it exists
    if (Test-Path $targetClaudeFile) {
        $backupName = "CLAUDE.md.backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
        $backupPath = Join-Path $Target $backupName
        Copy-Item $targetClaudeFile $backupPath
        Write-Host "[BACKUP] Backed up existing CLAUDE.md to $backupName" -ForegroundColor Yellow
    }
    
    # Copy the agent file
    Copy-Item $agentFile $targetClaudeFile -Force
    Write-Host "[SUCCESS] Deployed agent '$Agent' to $Target" -ForegroundColor Green
    Write-Host "          Agent is now active as CLAUDE.md" -ForegroundColor Gray
}

function Pull-Updates {
    Write-Host "[SYNC] Pulling latest agents from GitHub..." -ForegroundColor Cyan
    
    Push-Location $AgentsRepo
    git pull origin main
    Pop-Location
    
    Write-Host "[SUCCESS] Agents updated successfully!" -ForegroundColor Green
}

function Push-Agent {
    param(
        [string]$SourcePath,
        [string]$AgentName
    )
    
    if (-not (Test-Path $SourcePath)) {
        Write-Host "[ERROR] Source file not found: $SourcePath" -ForegroundColor Red
        return
    }
    
    $targetFile = Join-Path $AgentsDir "$AgentName.md"
    Copy-Item $SourcePath $targetFile -Force
    
    Push-Location $AgentsRepo
    git add .
    git commit -m "Add/Update agent: $AgentName"
    git push origin main
    Pop-Location
    
    Write-Host "[SUCCESS] Agent '$AgentName' pushed to repository!" -ForegroundColor Green
}

function Show-Help {
    $helpText = @"

Claude Code Agents Manager
==========================

USAGE:
    .\sync-agents.ps1 [action] [agent-name] [target-path]

ACTIONS:
    list                List all available agents
    deploy <name>       Deploy an agent to current directory (or specified path)
    pull                Pull latest agents from GitHub
    push <file> <name>  Push a local CLAUDE.md to the repository
    help                Show this help message

EXAMPLES:
    # List all available agents
    .\sync-agents.ps1 list
    
    # Deploy WoW addon agent to current directory
    .\sync-agents.ps1 deploy wow-addon-development
    
    # Deploy to specific directory
    .\sync-agents.ps1 deploy nextjs-azure-development "C:\Projects\MyApp"
    
    # Pull latest updates from GitHub
    .\sync-agents.ps1 pull
    
    # Push local CLAUDE.md to repository
    .\sync-agents.ps1 push ".\CLAUDE.md" "my-custom-agent"

"@
    Write-Host $helpText -ForegroundColor Cyan
}

# Main execution
switch ($Action.ToLower()) {
    "list" {
        Get-AvailableAgents
    }
    "deploy" {
        if (-not $AgentName) {
            Write-Host "[ERROR] Please specify an agent name!" -ForegroundColor Red
            Write-Host "Use 'sync-agents list' to see available agents" -ForegroundColor Yellow
        } else {
            Deploy-Agent -Agent $AgentName -Target $TargetPath
        }
    }
    "pull" {
        Pull-Updates
    }
    "push" {
        if (-not $AgentName -or -not $TargetPath) {
            Write-Host "[ERROR] Please specify both source file and agent name!" -ForegroundColor Red
            Write-Host "Example: .\sync-agents.ps1 push '.\CLAUDE.md' 'my-agent'" -ForegroundColor Yellow
        } else {
            Push-Agent -SourcePath $AgentName -AgentName $TargetPath
        }
    }
    "help" {
        Show-Help
    }
    default {
        Write-Host "[ERROR] Unknown action: $Action" -ForegroundColor Red
        Show-Help
    }
}