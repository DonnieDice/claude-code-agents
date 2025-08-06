# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a PowerShell terminal customization theme project called "Raspberry Orgasm Terminal Theme". It's not a Node.js application but a collection of configuration files and scripts for Windows Terminal customization.

## Key Commands

### Installation
```powershell
# One-line install
iwr -useb https://raw.githubusercontent.com/donniedice/raspberry-orgasm-terminal/main/install.ps1 | iex
```

### Development Commands
Since this is a configuration project, there are no build/test commands. Key operations:
- Edit configurations: Modify files in `/config/`, `/themes/`, or `/scripts/`
- Test changes: Run `reload` in PowerShell after modifying `Microsoft.PowerShell_profile.ps1`
- Validate JSON: Ensure all JSON files in `/config/` and `/themes/` are valid

## Architecture

### Core Components
1. **Installer Script** (`install.ps1`): PowerShell script that automates setup
   - Installs prerequisites via winget/scoop
   - Copies configuration files
   - Sets up PowerShell profile

2. **Configuration Files**:
   - `config/Microsoft.PowerShell_profile.ps1`: PowerShell profile with aliases, functions, and module imports
   - `config/terminal-settings.json`: Windows Terminal configuration with keybindings and theme
   - `themes/rgx.omp.json`: Oh My Posh prompt theme definition

3. **Helper Scripts** (`/scripts/`): Small utilities for opening admin terminals

### Key Technologies
- **PowerShell** (Windows PowerShell, not PowerShell Core)
- **Oh My Posh**: Prompt theming engine
- **Windows Terminal**: Modern terminal emulator
- **CLI Tools**: bat, ripgrep, fzf, zoxide, micro, lsd, git-delta

### Important Patterns
- All user-facing commands are aliased in the PowerShell profile
- Terminal keybindings follow a Ctrl+Shift pattern for consistency
- Color scheme uses raspberry/burgundy theme (#8B0051 as primary)
- JSON configurations should maintain existing formatting style

## Development Notes

When modifying this project:
1. Test all PowerShell functions by sourcing the profile: `. ./config/Microsoft.PowerShell_profile.ps1`
2. Validate JSON files before committing (terminal settings and Oh My Posh themes)
3. Maintain compatibility with Windows PowerShell (not PowerShell Core/7)
4. Update documentation in `/docs/` when adding new features
5. Follow existing alias naming conventions (short, memorable names)