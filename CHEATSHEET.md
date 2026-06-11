# 📋 mc - Quick Reference Guide

## Installation

```bash
curl -fsSL https://raw.githubusercontent.com/yourusername/mc/main/install.sh | bash
export PATH="$HOME/.local/bin:$PATH"
source ~/.zshrc
```

## Uninstall

```bash
# Automatic uninstall
curl -fsSL https://raw.githubusercontent.com/yourusername/mc/main/uninstall.sh | bash

# Or manual
rm ~/.local/bin/mc
rm -rf ~/.mc  # Optional: keep if you want to preserve settings
```

## First Time

```bash
mc setup          # Interactive setup
mc list           # See all platforms
mc config         # Edit configuration
```

## Basic Usage

```bash
# Interactive mode
mc                # Default platform
mc kimi           # Specific platform
mc openrouter     # Another platform

# With prompt
mc deep "code"
mc kimi "code"
mc openrouter "code"
```

## Platforms

| Command | Platform | Models |
|---------|----------|--------|
| `mc deep` | DeepSeek | v4-pro, v4-flash |
| `mc kimi` | Kimi | k2.6 |
| `mc or` | OpenRouter | 200+ |
| `mc gemini` | Gemini | 1.5-pro, 1.5-flash |
| `mc deepseek` | DeepSeek | v4-pro |

## Configuration

```bash
# View config
cat ~/.mc/config.json

# Edit config
mc config

# Add API key
mc config
# Then edit the JSON file
```

## Examples

```bash
# Write a function
mc deep "write a python function to sort list"

# Code review (with specific model)
mc or "meta-llama/llama-3.1-8b" "review this code"

# Chinese documentation
mc kimi "编写项目文档"

# Quick debugging
mc deep "debug this error message"

# Use Gemini
mc gemini "explain how recursion works"
mc gemini "write a React component"

# Interactive session
mc kimi
# Then type your prompts
```

## Tips & Tricks

### Create Aliases

Add to `~/.zshrc`:

```bash
alias cc="mc"
alias cc-deep="mc deep"
alias cc-kimi="mc kimi"
alias cc-or="mc openrouter"
```

### Use in Scripts

```bash
#!/bin/bash
# Generate boilerplate
mc deep "generate express.js boilerplate"

# Create tests
mc deep "write jest unit tests for this function"
```

### Environment Variables

Override settings:

```bash
# Use different API key
export ANTHROPIC_AUTH_TOKEN="sk-custom-key"
mc deep

# Use different model
export ANTHROPIC_MODEL="custom-model"
mc

# Reset to default
unset ANTHROPIC_AUTH_TOKEN
mc
```

## Troubleshooting

### Command not found

```bash
# Check if installed
which mc

# If not found, add to PATH
export PATH="$HOME/.local/bin:$PATH"
source ~/.zshrc

# Try again
mc help
```

### API Key Error

```bash
# Edit config
mc config

# Verify API key is correct and has credits
# Save and try again
mc list
```

### Can't find Claude Code

```bash
# Install Claude Code
npm install -g @anthropic-ai/claude-code

# Verify
claude --version

# Try mc again
mc setup
```

### jq not found

```bash
# Install jq for better config management
brew install jq        # macOS
sudo apt install jq    # Linux

# mc still works without jq, but with limitations
```

### Gemini LiteLLM not running

```bash
# Terminal 1: Start LiteLLM proxy
export GEMINI_API_KEY="AIza-your-key"
pip install litellm
cd ~/gemini-litellm
litellm --config config.yaml --port 4000

# Terminal 2: Use mc
mc gemini
```

**Full Gemini setup:** See GEMINI-SETUP.md

## File Locations

```
~/.mc/
  └── config.json      # Your configuration

~/.local/bin/
  └── mc               # The executable

~/.claude/
  └── settings.json    # Claude Code settings (preserved!)
```

## Common Workflows

### 1. Quick Code Generation

```bash
mc deep "create a REST API endpoint"
mc deep "write unit tests"
mc deep "optimize this code"
```

### 2. Language-Specific

```bash
# Python
mc or "meta-llama/llama-3.1-70b" "write FastAPI app"

# Go
mc deep "write Go HTTP server"

# Rust
mc or "meta-llama/llama-3.1-8b" "write Rust CLI"
```

### 3. Cost-Effective

```bash
# Use cheaper models for simple tasks
mc or "meta-llama/llama-3.1-8b" "explain this code"

# Use powerful models for complex tasks
mc or "@gpt-4-turbo" "architecture design review"
```

### 4. Language-Optimized

```bash
# Chinese content
mc kimi "用中文编写API文档"

# English (DeepSeek is good)
mc deep "write comprehensive README"
```

## Advanced

### Add Custom Platform

Edit `~/.mc/config.json`:

```json
{
  "platforms": {
    "custom": {
      "base_url": "https://your-api.com/anthropic",
      "api_key": "your-key",
      "model": "model-name",
      "small_model": "model-name"
    }
  }
}
```

Then use:

```bash
mc custom "your prompt"
```

### Change Default Platform

Edit `~/.mc/config.json`:

```json
{
  "default": "kimi",    // Change this
  ...
}
```

Now `mc` without args uses Kimi.

### Update Tool

```bash
# Check for updates
curl -fsSL https://raw.githubusercontent.com/yourusername/mc/main/install.sh | bash

# Or manually update
mc --version
# Then check GitHub for new versions
```

## Keyboard Shortcuts (in interactive mode)

```
Esc             Stop current task
Esc Esc         Open rewind menu
Ctrl+C          Hard stop
Tab             Autocomplete
```

See Claude Code docs for more: https://code.claude.com/docs

## Need Help?

```bash
# Show help
mc help

# See all commands
mc help

# Edit config
mc config

# View setup
mc setup

# List platforms
mc list
```

---

**More Info:**
- GitHub: https://github.com/yourusername/mc
- Claude Code: https://code.claude.com
- API Docs: https://api-docs.deepseek.com
