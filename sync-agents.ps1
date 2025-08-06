# Claude Code Agents Sync Script
# This script syncs both Claude Code agents and CLAUDE.md instruction files

param(
    [Parameter(Position=0)]
    [string]$Action = "list",
    
    [Parameter(Position=1)]
    [string]$AgentName = "",
    
    [Parameter(Position=2)]
    [string]$TargetPath = (Get-Location).Path
)

$AgentsRepo = $PSScriptRoot
$ClaudeAgentsDir = Join-Path $AgentsRepo "claude-agents"
$InstructionsDir = Join-Path $AgentsRepo "instructions"
$ConfigsDir = Join-Path $AgentsRepo "configs"

function Get-AvailableAgents {
    Write-Host "`n[CLAUDE CODE AGENTS] Specialized Agents:" -ForegroundColor Cyan
    Write-Host "=========================================" -ForegroundColor Cyan
    
    if (Test-Path $ClaudeAgentsDir) {
        Get-ChildItem -Path $ClaudeAgentsDir -Filter "*.md" | ForEach-Object {
            $name = $_.BaseName
            $content = Get-Content $_.FullName -First 10 -ErrorAction SilentlyContinue
            
            # Extract YAML frontmatter
            $description = ""
            $model = ""
            $color = ""
            
            $inFrontmatter = $false
            foreach ($line in $content) {
                if ($line -eq "---") {
                    if ($inFrontmatter) { break }
                    $inFrontmatter = $true
                    continue
                }
                if ($inFrontmatter) {
                    if ($line -match "^description:\s*(.+)") {
                        $description = $matches[1]
                    }
                    if ($line -match "^model:\s*(.+)") {
                        $model = $matches[1]
                    }
                    if ($line -match "^color:\s*(.+)") {
                        $color = $matches[1]
                    }
                }
            }
            
            Write-Host "`n  >> $name" -ForegroundColor Green
            if ($model) {
                Write-Host "     Model: $model" -ForegroundColor Gray
            }
            if ($description) {
                Write-Host "     $description" -ForegroundColor Gray
            }
        }
    }
    
    Write-Host "`n[INSTRUCTION FILES] CLAUDE.md Templates:" -ForegroundColor Yellow
    Write-Host "========================================" -ForegroundColor Yellow
    
    if (Test-Path $InstructionsDir) {
        Get-ChildItem -Path $InstructionsDir -Filter "*.md" | ForEach-Object {
            $name = $_.BaseName
            $content = Get-Content $_.FullName -First 10 -ErrorAction SilentlyContinue
            $description = ($content | Where-Object { $_ -match "^#" } | Select-Object -First 1) -replace "^#\s*", ""
            
            Write-Host "`n  >> $name" -ForegroundColor Magenta
            if ($description) {
                Write-Host "     $description" -ForegroundColor Gray
            }
        }
    }
    Write-Host "`n"
}

function Deploy-Agent {
    param(
        [string]$Agent,
        [string]$Target
    )
    
    # Check in claude-agents directory first
    $agentFile = Join-Path $ClaudeAgentsDir "$Agent.md"
    $isClaudeAgent = $true
    
    if (-not (Test-Path $agentFile)) {
        # Check in instructions directory
        $agentFile = Join-Path $InstructionsDir "$Agent.md"
        $isClaudeAgent = $false
        
        if (-not (Test-Path $agentFile)) {
            Write-Host "[ERROR] Agent or instruction file '$Agent' not found!" -ForegroundColor Red
            Write-Host "Use 'sync-agents list' to see available items" -ForegroundColor Yellow
            return
        }
    }
    
    if ($isClaudeAgent) {
        # Deploy as a Claude Code agent
        $claudeAgentsPath = Join-Path $env:USERPROFILE ".claude\agents"
        if (-not (Test-Path $claudeAgentsPath)) {
            New-Item -Path $claudeAgentsPath -ItemType Directory -Force | Out-Null
        }
        
        $targetFile = Join-Path $claudeAgentsPath "$Agent.md"
        
        # Backup existing agent if it exists
        if (Test-Path $targetFile) {
            $backupName = "$Agent.md.backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
            $backupPath = Join-Path $claudeAgentsPath $backupName
            Copy-Item $targetFile $backupPath
            Write-Host "[BACKUP] Backed up existing agent to $backupName" -ForegroundColor Yellow
        }
        
        Copy-Item $agentFile $targetFile -Force
        Write-Host "[SUCCESS] Deployed Claude Code agent '$Agent' to ~/.claude/agents/" -ForegroundColor Green
        Write-Host "          Agent is now available in Claude Code" -ForegroundColor Gray
    } else {
        # Deploy as CLAUDE.md instruction file
        $targetClaudeFile = Join-Path $Target "CLAUDE.md"
        
        # Backup existing CLAUDE.md if it exists
        if (Test-Path $targetClaudeFile) {
            $backupName = "CLAUDE.md.backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
            $backupPath = Join-Path $Target $backupName
            Copy-Item $targetClaudeFile $backupPath
            Write-Host "[BACKUP] Backed up existing CLAUDE.md to $backupName" -ForegroundColor Yellow
        }
        
        Copy-Item $agentFile $targetClaudeFile -Force
        Write-Host "[SUCCESS] Deployed instruction file '$Agent' to $Target" -ForegroundColor Green
        Write-Host "          File is now active as CLAUDE.md" -ForegroundColor Gray
    }
}

function Pull-Updates {
    Write-Host "[SYNC] Pulling latest from GitHub..." -ForegroundColor Cyan
    
    Push-Location $AgentsRepo
    git pull origin main
    Pop-Location
    
    Write-Host "[SUCCESS] Repository updated successfully!" -ForegroundColor Green
}

function Push-Agent {
    param(
        [string]$SourcePath,
        [string]$AgentName,
        [string]$Type = "instruction"
    )
    
    if (-not (Test-Path $SourcePath)) {
        Write-Host "[ERROR] Source file not found: $SourcePath" -ForegroundColor Red
        return
    }
    
    if ($Type -eq "agent") {
        $targetDir = $ClaudeAgentsDir
    } else {
        $targetDir = $InstructionsDir
    }
    
    $targetFile = Join-Path $targetDir "$AgentName.md"
    Copy-Item $SourcePath $targetFile -Force
    
    Push-Location $AgentsRepo
    git add .
    git commit -m "Add/Update $Type : $AgentName"
    git push origin main
    Pop-Location
    
    Write-Host "[SUCCESS] $Type '$AgentName' pushed to repository!" -ForegroundColor Green
}

function Import-LocalAgents {
    Write-Host "[IMPORT] Importing local Claude Code agents..." -ForegroundColor Cyan
    
    $localAgentsPath = Join-Path $env:USERPROFILE ".claude\agents"
    
    if (-not (Test-Path $localAgentsPath)) {
        Write-Host "[INFO] No local agents directory found" -ForegroundColor Yellow
        return
    }
    
    $imported = 0
    Get-ChildItem -Path $localAgentsPath -Filter "*.md" | ForEach-Object {
        $targetFile = Join-Path $ClaudeAgentsDir $_.Name
        if (-not (Test-Path $targetFile)) {
            Copy-Item $_.FullName $targetFile
            Write-Host "  [+] Imported: $($_.BaseName)" -ForegroundColor Green
            $imported++
        } else {
            Write-Host "  [=] Already exists: $($_.BaseName)" -ForegroundColor Gray
        }
    }
    
    if ($imported -gt 0) {
        Write-Host "[SUCCESS] Imported $imported new agent(s)" -ForegroundColor Green
        Write-Host "Run 'sync-agents push-all' to upload to GitHub" -ForegroundColor Yellow
    }
}

function Show-Help {
    $helpText = @"

Claude Code Agents Manager
==========================

USAGE:
    .\sync-agents.ps1 [action] [agent-name] [target-path]

ACTIONS:
    list                    List all agents and instruction files
    deploy <name>           Deploy agent or instruction file
    pull                    Pull latest from GitHub
    push <file> <name>      Push instruction file to repository
    push-agent <file> <name>  Push Claude Code agent to repository
    import                  Import local agents from ~/.claude/agents
    help                    Show this help message

EXAMPLES:
    # List all available items
    .\sync-agents.ps1 list
    
    # Deploy Claude Code agent (goes to ~/.claude/agents/)
    .\sync-agents.ps1 deploy wow-addon-assistant
    
    # Deploy instruction file (goes to project as CLAUDE.md)
    .\sync-agents.ps1 deploy wow-addon-development
    
    # Import local agents to repository
    .\sync-agents.ps1 import
    
    # Push Claude Code agent
    .\sync-agents.ps1 push-agent "agent.md" "my-agent"

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
            Write-Host "[ERROR] Please specify an agent or instruction file name!" -ForegroundColor Red
            Write-Host "Use 'sync-agents list' to see available items" -ForegroundColor Yellow
        } else {
            Deploy-Agent -Agent $AgentName -Target $TargetPath
        }
    }
    "pull" {
        Pull-Updates
    }
    "push" {
        if (-not $AgentName -or -not $TargetPath) {
            Write-Host "[ERROR] Please specify both source file and name!" -ForegroundColor Red
            Write-Host "Example: .\sync-agents.ps1 push '.\CLAUDE.md' 'my-instruction'" -ForegroundColor Yellow
        } else {
            Push-Agent -SourcePath $AgentName -AgentName $TargetPath -Type "instruction"
        }
    }
    "push-agent" {
        if (-not $AgentName -or -not $TargetPath) {
            Write-Host "[ERROR] Please specify both source file and agent name!" -ForegroundColor Red
            Write-Host "Example: .\sync-agents.ps1 push-agent '.\agent.md' 'my-agent'" -ForegroundColor Yellow
        } else {
            Push-Agent -SourcePath $AgentName -AgentName $TargetPath -Type "agent"
        }
    }
    "import" {
        Import-LocalAgents
    }
    "help" {
        Show-Help
    }
    default {
        Write-Host "[ERROR] Unknown action: $Action" -ForegroundColor Red
        Show-Help
    }
}