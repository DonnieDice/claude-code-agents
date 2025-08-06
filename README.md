# Claude Code Agents Repository

Private repository for storing and managing custom Claude Code agents and configurations.

## Quick Start

### 1. Initial Setup (One-time)
```powershell
# Clone the repository (if not already done)
git clone https://github.com/donniedice/claude-code-agents.git
cd claude-code-agents

# Run setup to add to PATH
powershell -ExecutionPolicy Bypass -File setup-path.ps1
```

### 2. Using Agents

#### List Available Agents
```powershell
claude-agent list
# or shorter alias (after restart)
ca list
```

#### Deploy an Agent to Your Project
```powershell
# Deploy to current directory
claude-agent deploy wow-addon-development

# Deploy to specific directory
claude-agent deploy nextjs-azure-development "C:\Projects\MyApp"
```

#### Update Agents from GitHub
```powershell
claude-agent pull
```

#### Push New Agent to Repository
```powershell
# From a project with CLAUDE.md
claude-agent push ".\CLAUDE.md" "my-new-agent"
```

## Structure

```
claude-code-agents/
├── agents/              # Agent definition files (CLAUDE.md)
│   ├── wow-addon-development.md
│   ├── nextjs-azure-development.md
│   ├── nextcloud-integration.md
│   └── ...
├── configs/             # Configuration files
│   └── global-settings.json
├── examples/            # Example usage and templates
├── sync-agents.ps1      # PowerShell sync script
├── claude-agent.bat     # Windows batch wrapper
└── setup-path.ps1       # PATH setup script
```

## Available Agents

| Agent Name | Description | Use Case |
|------------|-------------|----------|
| `wow-addon-development` | World of Warcraft addon development | Lua scripting, Ace3 framework, ToC files |
| `nextjs-azure-development` | Next.js with Azure deployment | Web apps, Azure DevOps, Power Automate |
| `nextcloud-integration` | Nextcloud CLI integration | Task management, calendar sync |
| `blu-addon` | Better Level-Up addon | WoW sound events |
| `fflu-addon` | Final Fantasy Level-Up | FF sound integration |
| `srlu-addon` | Simple sound addon | Basic WoW sounds |
| `terminal-project` | Terminal/shell projects | CLI tools development |

## How It Works

1. **Agent Files**: Each `.md` file in `/agents/` is a complete CLAUDE.md instruction set
2. **Deployment**: The `deploy` command copies the selected agent as `CLAUDE.md` to your project
3. **Backup**: Existing `CLAUDE.md` files are automatically backed up with timestamps
4. **Sync**: The `pull` command fetches latest agents from GitHub
5. **Contribution**: The `push` command adds your local agents to the shared repository

## Creating New Agents

### Agent File Format
Create a new `.md` file in the `agents/` directory following this structure:

```markdown
# Agent Name

Brief description of what this agent helps with.

## Repository Overview
Describe the project structure and purpose

## Architecture
Technical details and patterns used

## Development Workflow
Step-by-step instructions for common tasks

## Important Notes
Critical information and gotchas
```

### Best Practices
- Keep agents focused on specific domains or technologies
- Include concrete examples and file paths
- Document any required dependencies or tools
- Specify version compatibility where relevant

## Command Reference

### List Commands
```powershell
claude-agent list              # Show all available agents
claude-agent help              # Show help information
```

### Deploy Commands
```powershell
claude-agent deploy <agent>    # Deploy to current directory
claude-agent deploy <agent> <path>  # Deploy to specific path
```

### Sync Commands
```powershell
claude-agent pull              # Pull latest from GitHub
claude-agent push <file> <name>  # Push new agent to repo
```

## Troubleshooting

### PowerShell Execution Policy
If you get execution policy errors:
```powershell
powershell -ExecutionPolicy Bypass -File sync-agents.ps1 <command>
```

### PATH Not Working
After running setup, restart your terminal or run:
```powershell
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
```

### Agent Not Found
Ensure the agent name matches exactly (case-sensitive):
```powershell
claude-agent list  # Check exact names
```

## Contributing

1. Create your agent file locally
2. Test it in a project
3. Push to repository:
   ```powershell
   claude-agent push ".\CLAUDE.md" "descriptive-agent-name"
   ```

## Security Note

This is a **private repository**. Keep it private as it may contain project-specific information and development patterns.