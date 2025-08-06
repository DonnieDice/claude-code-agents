# Claude CLI Integration Guide

This guide explains how the Nextcloud Agent integrates with Claude CLI for natural language task and calendar management.

## 🤖 How It Works

The agent can be used in three ways with Claude:

1. **Natural Language** - Claude understands your intent
2. **Direct Commands** - Use specific nc-* commands  
3. **MCP Server** - Claude can directly access your Nextcloud

## 💬 Natural Language Examples

Just talk to Claude naturally:

```
claude "what tasks do I have due this week"
claude "show me tomorrow's calendar"
claude "add a task to call mom on Sunday"
claude "schedule a meeting with John next Tuesday at 2pm"
claude "mark my website update task as complete"
```

## 🔧 Direct Commands

For more control, use specific commands:

### Tasks
```bash
# List all tasks
claude nc-tasks

# Add a task
claude nc-add-task "Task title" "Description" "2024-12-31"

# With Claude's help
claude "help me organize my tasks for next week"
```

### Calendar
```bash
# List events
claude nc-events

# Add an event  
claude nc-add-event "Meeting" "2024-12-20 14:00" "Office"

# With Claude's context
claude "find a free slot for a 1-hour meeting this week"
```

## 🔌 MCP Integration

The Model Context Protocol (MCP) integration allows Claude to:
- Access your calendar and tasks directly
- Create complex schedules
- Provide intelligent suggestions
- Integrate with other tools

### Setup MCP

1. The installer creates MCP configuration automatically
2. Claude can now access Nextcloud in conversations
3. No need to use specific commands

### MCP Examples

```
You: "What's my day look like?"
Claude: *checks your calendar* You have 3 meetings today...

You: "Remind me to prepare for tomorrow's presentation"
Claude: *creates task* I've added a task "Prepare for presentation" due today...

You: "Find time for a workout this week"
Claude: *analyzes calendar* You have free time on Tuesday at 6 AM...
```

## 🎯 Advanced Usage

### Batch Operations
```
claude "create tasks for my project milestone:
- Design review by Friday
- Code implementation next week  
- Testing phase after that"
```

### Smart Scheduling
```
claude "schedule weekly team meetings for the next month, avoiding holidays"
```

### Task Management
```
claude "show me all high-priority tasks that are overdue"
claude "move all December tasks to January"
```

## 🔗 Combining with Other Tools

Claude can combine Nextcloud with other capabilities:

```
# Research and schedule
claude "research best practices for React testing and schedule time to implement them"

# Code review reminders
claude "after I commit this code, remind me to schedule a code review"

# Project planning
claude "create a project timeline for the new feature and add all tasks"
```

## ⚙️ Configuration for Claude

The agent is configured in:
- `%APPDATA%\claude\nextcloud-agent\config.json`

Claude-specific settings:
```json
{
    "claude": {
        "autoSync": true,
        "notifications": true,
        "defaultView": "week"
    }
}
```

## 🚀 Tips for Claude Users

1. **Be Specific**: "Add task due Friday" vs "Add task"
2. **Use Context**: Claude remembers your conversation
3. **Batch Commands**: Ask for multiple things at once
4. **Time Zones**: Specify if different from system default
5. **Recurring Events**: Claude can handle "every Monday at 10 AM"

## 🐛 Troubleshooting Claude Integration

### "Claude doesn't see my calendar"
- Run `.\install-agent.ps1 -WithClaude` 
- Restart Claude CLI
- Check MCP server is running

### "Commands not working"
- Ensure agent is in Claude's PATH
- Check `%APPDATA%\claude\nextcloud-agent\`
- Verify config.json exists

### "Natural language not understood"
- Be more specific
- Use command format as fallback
- Check Claude's response for errors

## 📚 Examples by Use Case

### Daily Planning
```
claude "show me today's schedule and high priority tasks"
```

### Weekly Review  
```
claude "summarize what I accomplished this week based on completed tasks"
```

### Project Management
```
claude "create a project plan for the Q1 product launch with weekly milestones"
```

### Time Blocking
```
claude "block 2 hours tomorrow for deep work on the API redesign"
```

---

**Pro Tip**: Claude learns your patterns. The more you use it, the better it gets at understanding your scheduling preferences and task management style.