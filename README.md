# Claude Code Agents Repository

Private repository for managing Claude Code agents and CLAUDE.md instruction files.

## What's Included

### Claude Code Agents (3)
These are **actual Claude Code agents** that extend Claude's capabilities with specialized knowledge:

1. **wow-addon-assistant** - Expert on World of Warcraft addon development (Lua, XML, WoW API)
2. **brand-formatter** - Transforms documentation to match RGX Mods brand standards
3. **image-generation-agent** - AI image generation with 10+ providers and automatic fallback

### Instruction Files (8)
These are **CLAUDE.md files** that provide project-specific context:
- WoW addon projects (BLU, FFLU, SRLU, etc.)
- Next.js Azure development
- Nextcloud integration
- Terminal projects

### Tools
- **Image Generation Tool** - Generate AI images using multiple providers (FREE option included)

## Quick Start

### 1. Initial Setup (One-time)
```powershell
# Clone the repository
git clone https://github.com/donniedice/claude-code-agents.git
cd claude-code-agents

# Run setup to add to PATH
powershell -ExecutionPolicy Bypass -File setup-path.ps1
```

### 2. Using the Manager

#### List Everything
```powershell
claude-agent list
# Shows both Claude Code agents and instruction files
```

#### Deploy a Claude Code Agent
```powershell
# Deploys to ~/.claude/agents/ for use in Claude Code
claude-agent deploy wow-addon-assistant
claude-agent deploy brand-formatter
```

#### Deploy an Instruction File
```powershell
# Deploys as CLAUDE.md to your project directory
claude-agent deploy wow-addon-development

# To specific directory
claude-agent deploy nextjs-azure-development "C:\Projects\MyApp"
```

## Understanding the Difference

### Claude Code Agents
- **Location**: Deploy to `~/.claude/agents/`
- **Purpose**: Extend Claude Code with specialized capabilities
- **Format**: Markdown with YAML frontmatter (name, model, color, description)
- **Usage**: Available as specialized agents when using Claude Code
- **Example**: `wow-addon-assistant` provides WoW API expertise

### Instruction Files (CLAUDE.md)
- **Location**: Deploy to project directories as `CLAUDE.md`
- **Purpose**: Provide project-specific context and guidelines
- **Format**: Standard markdown documentation
- **Usage**: Claude reads these automatically when working in a project
- **Example**: `wow-addon-development.md` explains your addon's architecture

## Repository Structure

```
claude-code-agents/
├── claude-agents/       # Actual Claude Code agents
│   ├── wow-addon-assistant.md
│   ├── brand-formatter.md
│   └── image-generation-agent.md
├── instructions/        # CLAUDE.md instruction templates
│   ├── wow-addon-development.md
│   ├── nextjs-azure-development.md
│   └── ...
├── tools/               # Standalone tools
│   └── image-generation/
│       ├── image_generator.py
│       ├── config.json
│       ├── setup.ps1
│       └── generate.bat
├── configs/             # Configuration files
├── sync-agents.ps1      # PowerShell management script
├── claude-agent.bat     # Windows batch wrapper
└── setup-path.ps1       # PATH setup script
```

## Command Reference

### Core Commands
```powershell
claude-agent list                    # List all agents and instructions
claude-agent deploy <name>           # Deploy agent or instruction
claude-agent pull                    # Pull latest from GitHub
claude-agent import                  # Import local agents from ~/.claude/agents
claude-agent help                    # Show help
```

### Contributing
```powershell
# Push a new instruction file
claude-agent push ".\CLAUDE.md" "my-instruction"

# Push a new Claude Code agent
claude-agent push-agent ".\agent.md" "my-agent"
```

## Creating New Items

### Creating a Claude Code Agent
```markdown
---
name: my-agent
description: Brief description of agent's expertise
model: sonnet
color: cyan
---

You are [agent name], an expert AI agent specializing in...
[Detailed instructions and knowledge base]
```

### Creating an Instruction File
```markdown
# Project Name

This file provides guidance to Claude Code when working with this repository.

## Repository Overview
[Project structure and purpose]

## Architecture
[Technical details]

## Development Workflow
[Common tasks and procedures]
```

## Image Generation Tool

### Quick Setup
```powershell
# Navigate to the tool directory
cd tools/image-generation

# Run the setup script
powershell -ExecutionPolicy Bypass .\setup.ps1
```

### Generate Images (FREE - No API Key Required)
```powershell
# From tools/image-generation directory
python image_generator.py "a beautiful sunset over mountains"

# Or use the batch file
.\generate.bat "cyberpunk city at night"
```

### Enable Premium Providers (Optional)
1. Edit `tools/image-generation/.env`
2. Add your API keys:
   - OpenAI (DALL-E 3): Best quality
   - Stability AI: Official Stable Diffusion
   - Together AI: Fast generation
   - And 7+ more providers

### Examples
```powershell
# Free generation (Pollinations)
python image_generator.py "fantasy dragon"

# Specific provider (if configured)
python image_generator.py "robot portrait" openai 1024x1024

# Auto-fallback (tries all enabled providers)
python image_generator.py "space station"
```

## Advanced Usage

### Import All Local Agents
```powershell
# Import agents from ~/.claude/agents to repository
claude-agent import
```

### Sync with GitHub
```powershell
# Pull latest updates
claude-agent pull

# After making local changes
git add .
git commit -m "Update agents"
git push
```

## Troubleshooting

### PowerShell Execution Policy
```powershell
powershell -ExecutionPolicy Bypass -File sync-agents.ps1 <command>
```

### PATH Not Working
Restart terminal or run:
```powershell
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
```

### Agent vs Instruction?
- **Agent**: Special capabilities, deploys to `~/.claude/agents/`
- **Instruction**: Project context, deploys as `CLAUDE.md`

## Security Note

This is a **private repository**. Keep it private as it contains your custom agents and project-specific patterns.