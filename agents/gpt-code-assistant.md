# GPT Code Assistant Agent

## Description
An intelligent code assistant that leverages GPT models through Claude Code Router to help with programming tasks, code generation, debugging, and technical explanations.

## Configuration
This agent uses the Claude Code Router to route requests to GPT models via OpenRouter.

## Capabilities
- Generate code in multiple programming languages
- Debug and fix code issues
- Explain complex code concepts
- Suggest optimizations and best practices
- Help with API integration
- Assist with documentation writing
- Provide code reviews

## Setup Instructions

### 1. Prerequisites
- Claude Code Router installed (`npm install -g @musistudio/claude-code-router`)
- OpenRouter API key configured
- Router service running (`ccr start`)

### 2. Configuration
Ensure your `~/.claude-code-router/config.json` is configured with:
```json
{
  "Providers": [{
    "name": "openrouter",
    "api_base_url": "https://openrouter.ai/api/v1/chat/completions",
    "api_key": "your-openrouter-api-key",
    "models": [
      "openai/gpt-4-turbo",
      "openai/gpt-3.5-turbo"
    ]
  }],
  "Router": {
    "default": "openrouter,openai/gpt-3.5-turbo",
    "rules": {
      "code_generation": "openrouter,openai/gpt-4-turbo"
    }
  }
}
```

## Usage Examples

### Basic Code Generation
```bash
ccr code "Write a Python function to calculate fibonacci numbers"
```

### API Call for Complex Tasks
```bash
curl -X POST http://127.0.0.1:3456/v1/messages \
  -H "Content-Type: application/json" \
  -d '{
    "model": "openrouter,openai/gpt-4-turbo",
    "messages": [
      {"role": "system", "content": "You are an expert code assistant."},
      {"role": "user", "content": "Help me optimize this SQL query..."}
    ],
    "max_tokens": 500
  }'
```

### Python Integration
```python
import requests
import json

def ask_gpt_assistant(prompt, context=""):
    url = "http://127.0.0.1:3456/v1/messages"
    
    messages = []
    if context:
        messages.append({"role": "system", "content": context})
    messages.append({"role": "user", "content": prompt})
    
    payload = {
        "model": "openrouter,openai/gpt-4-turbo",
        "messages": messages,
        "max_tokens": 500
    }
    
    response = requests.post(url, json=payload)
    result = response.json()
    
    if "content" in result:
        return result["content"][0]["text"]
    return None

# Example usage
code = ask_gpt_assistant(
    "Write a function to validate email addresses",
    context="Generate Python code with type hints and docstrings"
)
print(code)
```

## Common Tasks

### 1. Code Review
```bash
# Send code for review
curl -X POST http://127.0.0.1:3456/v1/messages \
  -H "Content-Type: application/json" \
  -d '{
    "model": "openrouter,openai/gpt-4-turbo",
    "messages": [
      {"role": "system", "content": "You are a code reviewer. Analyze for bugs, performance, and best practices."},
      {"role": "user", "content": "Review this code: [paste code here]"}
    ]
  }'
```

### 2. Debug Assistance
```bash
# Get debugging help
curl -X POST http://127.0.0.1:3456/v1/messages \
  -H "Content-Type: application/json" \
  -d '{
    "model": "openrouter,openai/gpt-4-turbo",
    "messages": [
      {"role": "user", "content": "I have this error: [error message]. Here is my code: [code]. How do I fix it?"}
    ]
  }'
```

### 3. Documentation Generation
```bash
# Generate documentation
curl -X POST http://127.0.0.1:3456/v1/messages \
  -H "Content-Type: application/json" \
  -d '{
    "model": "openrouter,openai/gpt-3.5-turbo",
    "messages": [
      {"role": "user", "content": "Generate JSDoc comments for this JavaScript function: [function code]"}
    ]
  }'
```

## Advanced Integration

### PowerShell Function
```powershell
function Invoke-GPTAssistant {
    param(
        [string]$Prompt,
        [string]$Model = "openai/gpt-3.5-turbo"
    )
    
    $body = @{
        model = "openrouter,$Model"
        messages = @(
            @{
                role = "user"
                content = $Prompt
            }
        )
        max_tokens = 500
    } | ConvertTo-Json
    
    $response = Invoke-RestMethod -Uri "http://127.0.0.1:3456/v1/messages" `
        -Method Post `
        -ContentType "application/json" `
        -Body $body
    
    return $response.content[0].text
}

# Usage
Invoke-GPTAssistant -Prompt "Explain async/await in JavaScript"
```

### Batch Processing Script
```python
#!/usr/bin/env python3
import requests
import json
import sys

def process_code_files(file_list, task="review"):
    """Process multiple code files with GPT assistant"""
    
    url = "http://127.0.0.1:3456/v1/messages"
    results = {}
    
    for filepath in file_list:
        with open(filepath, 'r') as f:
            code = f.read()
        
        prompt = f"Please {task} this code:\n\n{code}"
        
        payload = {
            "model": "openrouter,openai/gpt-4-turbo",
            "messages": [{"role": "user", "content": prompt}],
            "max_tokens": 1000
        }
        
        response = requests.post(url, json=payload)
        results[filepath] = response.json()
    
    return results

if __name__ == "__main__":
    files = sys.argv[1:]
    results = process_code_files(files, task="review and suggest improvements for")
    
    for file, result in results.items():
        print(f"\n=== {file} ===")
        print(result["content"][0]["text"])
```

## Tips & Best Practices

1. **Model Selection**: 
   - Use `gpt-3.5-turbo` for quick responses and simple tasks
   - Use `gpt-4-turbo` for complex code generation and analysis

2. **Token Management**:
   - Keep prompts concise to avoid token limits
   - Adjust `max_tokens` based on expected response length

3. **Context Preservation**:
   - Include previous messages for multi-turn conversations
   - Use system messages to set consistent behavior

4. **Error Handling**:
   - Always check for errors in responses
   - Implement retry logic for failed requests

5. **Rate Limiting**:
   - Be mindful of OpenRouter credits
   - Implement delays between batch requests

## Troubleshooting

### Router Not Responding
```bash
# Check if service is running
ccr status

# Restart service
ccr stop && ccr start
```

### Token Limit Errors
- Reduce prompt length
- Lower `max_tokens` setting
- Use model with higher context window

### Authentication Errors
- Verify OpenRouter API key
- Check credit balance at https://openrouter.ai

## Integration with Claude Code

This agent can be invoked from Claude Code using the Task tool:

```python
# In Claude Code, you can use:
Task(
    description="Code assistance",
    prompt="Use the GPT code assistant to generate a Python web scraper",
    subagent_type="gpt-code-assistant"
)
```

## Security Considerations

- Never commit API keys to version control
- Use environment variables for sensitive data
- Validate and sanitize code outputs before execution
- Review generated code for security vulnerabilities

## Performance Optimization

- Cache frequently used responses
- Batch similar requests
- Use streaming for long responses
- Implement request queuing for high volume

---

Last Updated: January 2025
Version: 1.0.0