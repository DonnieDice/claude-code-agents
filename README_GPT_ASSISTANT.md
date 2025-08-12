# GPT Code Assistant Setup Guide

## ✅ Setup Complete!

Your GPT Code Assistant is now configured and ready to use through the Claude Code Router.

## 🚀 Quick Start

### Simple Usage
```bash
# From anywhere in PowerShell or Command Prompt:
gpt "Write a Python function to reverse a string"
```

### From the claude-code-agents directory:
```powershell
.\gpt-assist.ps1 "Explain async/await in JavaScript"
```

## 📋 What Was Set Up

1. **Claude Code Router Configuration** (`~/.claude-code-router/config.json`)
   - Configured to use OpenRouter with your API key
   - Models available: GPT-3.5-Turbo, GPT-4-Turbo, Claude, Llama
   - Default model: GPT-3.5-Turbo (fast and economical)

2. **GPT Assistant Script** (`gpt-assist.ps1`)
   - PowerShell wrapper for easy GPT access
   - Automatic router startup
   - Response copied to clipboard
   - Multiple modes (basic, code generation, custom context)

3. **Batch File** (`gpt.bat`)
   - Quick access from anywhere
   - No need to type full script path

## 🎯 Usage Examples

### Basic Questions
```bash
gpt "What is a REST API?"
gpt "How do I center a div in CSS?"
```

### Code Generation
```powershell
.\gpt-assist.ps1 "Create a Node.js Express server" -CodeGeneration
.\gpt-assist.ps1 "Write unit tests for a login function" -CodeGeneration
```

### Debugging Help
```powershell
.\gpt-assist.ps1 "TypeError: Cannot read property 'map' of undefined" -Context "Debug this React error"
```

### Using GPT-4 for Complex Tasks
```powershell
.\gpt-assist.ps1 "Design a microservices architecture for an e-commerce platform" -Model "openai/gpt-4-turbo" -MaxTokens 1000
```

## 🔧 Configuration

### Change Default Model
Edit `gpt-assist.ps1` and modify the `$Model` parameter default value.

### Add to PATH (Optional)
To use `gpt` command from anywhere:
1. Add `C:\Users\JosephGettings\claude-code-agents` to your PATH
2. Restart your terminal

### Router Management
```bash
ccr status  # Check if router is running
ccr start   # Start the router
ccr stop    # Stop the router
```

## 💡 Tips

1. **Credits**: Monitor your OpenRouter usage at https://openrouter.ai
2. **Model Selection**: 
   - Use GPT-3.5 for quick, simple tasks
   - Use GPT-4 for complex coding and architecture questions
3. **Token Limits**: Increase `-MaxTokens` for longer responses
4. **Context**: Provide context for better responses

## 🛠️ Troubleshooting

### "Router not responding"
```bash
ccr stop
ccr start
```

### "Insufficient credits"
- Check balance at https://openrouter.ai
- Add credits to your account

### "Token limit exceeded"
- Shorten your prompt
- Use a model with larger context window

## 📊 Available Models

Through your OpenRouter configuration:
- `openai/gpt-3.5-turbo` - Fast, economical
- `openai/gpt-4-turbo` - Most capable
- `openai/gpt-4` - Stable, reliable
- `anthropic/claude-3-haiku-20240307` - Fast Claude model
- `google/gemini-pro` - Google's model
- `meta-llama/llama-3.1-70b-instruct` - Open source

## 🔗 Integration with Claude Code

When using Claude Code, you can now leverage GPT for specific tasks:

```python
# In your Claude Code conversation:
# "Use GPT to help with this specific algorithm"
# "Ask GPT for alternative solutions"
```

## 📝 Notes

- Responses are automatically copied to clipboard
- Router runs in background (minimal resource usage)
- All requests go through localhost:3456
- Secure: API keys never exposed in commands

---

Setup completed successfully! Start using: `gpt "your question here"`