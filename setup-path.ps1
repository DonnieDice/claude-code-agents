# Setup script to add claude-agent to PATH

$repoPath = $PSScriptRoot
$currentPath = [Environment]::GetEnvironmentVariable("Path", "User")

if ($currentPath -notlike "*$repoPath*") {
    Write-Host "Adding claude-code-agents to PATH..." -ForegroundColor Cyan
    
    # Add to user PATH
    $newPath = "$currentPath;$repoPath"
    [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
    
    # Also update current session
    $env:Path = "$env:Path;$repoPath"
    
    Write-Host "✅ Added to PATH successfully!" -ForegroundColor Green
    Write-Host "   You can now use 'claude-agent' from anywhere" -ForegroundColor Gray
    Write-Host "`n⚠️  Please restart your terminal for changes to take effect" -ForegroundColor Yellow
} else {
    Write-Host "✅ Already in PATH!" -ForegroundColor Green
}

# Create a quick alias for PowerShell profile
$profileContent = @"

# Claude Agent Manager Alias
Set-Alias -Name ca -Value "$repoPath\claude-agent.bat"
function Claude-Agent { & "$repoPath\claude-agent.bat" `$args }
"@

$profilePath = $PROFILE.CurrentUserAllHosts
if (-not (Test-Path $profilePath)) {
    New-Item -Path $profilePath -ItemType File -Force | Out-Null
}

$existingContent = Get-Content $profilePath -Raw -ErrorAction SilentlyContinue
if ($existingContent -notlike "*Claude Agent Manager*") {
    Add-Content -Path $profilePath -Value $profileContent
    Write-Host "`n✅ Added PowerShell aliases:" -ForegroundColor Green
    Write-Host "   - 'ca' as shortcut for claude-agent" -ForegroundColor Gray
    Write-Host "   - 'Claude-Agent' function for PowerShell" -ForegroundColor Gray
}