# 🚀 mc

Your personal Claude Code tool with **multiple model support**.

Switch between DeepSeek, Kimi, OpenRouter, and more with one command.

```bash
mc              # Interactive
mc kimi         # Switch to Kimi  
mc deep "code"  # DeepSeek with prompt
```

## 📦 Installation

```bash
curl -fsSL https://raw.githubusercontent.com/akfajricrt/mc/main/install.sh | bash
```

Add to `~/.zshrc` or `~/.bashrc`:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

Then reload:

```bash
source ~/.zshrc
```

## 🗑️ Uninstall

### Option 1: Automatic Uninstall (Recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/akfajricrt/mc/main/uninstall.sh | bash
```

This will:
- ✓ Remove the `mc` executable from `~/.local/bin/`
- ✓ Ask if you want to remove config directory (`~/.mc/`)
- ✓ Show instructions for removing PATH export

### Option 2: Manual Uninstall

**1. Remove executable:**

```bash
rm ~/.local/bin/mc
```

**2. Remove config directory (optional):**

```bash
rm -rf ~/.mc
```

**3. Clean up PATH export (optional):**

Edit `~/.zshrc` or `~/.bashrc` and remove:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

Then reload:

```bash
source ~/.zshrc
```

---

## 🚀 Quick Start

### First Time

```bash
mc setup
```

This creates `~/.mc/config.json` and walks you through setup.

### List Platforms

```bash
mc list
```

### Start Using

```bash
# Interactive mode
mc
mc kimi
mc openrouter

# With prompt
mc deep "write a function"
mc kimi "tulis kode python"
```

## ⚙️ Configuration

Config file: `~/.mc/config.json`

### Edit Config

```bash
mc config
```

### Add New Platform

Edit `~/.mc/config.json`:

```json
{
  "default": "deepseek",
  "platforms": {
    "myplatform": {
      "base_url": "https://api.example.com/anthropic",
      "api_key": "sk-...",
      "model": "model-name",
      "small_model": "model-name"
    }
  }
}
```

Then use:

```bash
mc myplatform "prompt"
```

## 📚 Commands

```bash
mc setup               # First-time setup
mc list                # List platforms
mc config              # Edit config
mc help                # Show help

mc                     # Interactive (default)
mc deep                # DeepSeek interactive
mc kimi                # Kimi interactive
mc openrouter          # OpenRouter interactive

mc deep "code"         # With prompt
mc kimi "code"         # With prompt
```

## 📋 Supported Platforms

### Quick Reference

- **DeepSeek** - `mc deep` or `mc deepseek`
- **Kimi** - `mc kimi`
- **OpenRouter** - `mc or` or `mc openrouter`
- **Gemini** - `mc gemini` (requires LiteLLM proxy)
- **Custom** - Add your own in config

### Detailed Setup

#### DeepSeek
- **Website:** https://platform.deepseek.com
- **Get API Key:** Create account → Dashboard → API Keys
- **Command:** `mc deep "your prompt"`

#### Kimi
- **Website:** https://platform.moonshot.cn
- **Get API Key:** Create account → Console → API Keys
- **Command:** `mc kimi "你的提示"`

#### OpenRouter
- **Website:** https://openrouter.ai
- **Get API Key:** https://openrouter.ai/keys
- **Supports:** 200+ models (Claude, Gemini, Llama, etc)
- **Command:** `mc or "@gpt-4" "your prompt"`

#### Gemini (via LiteLLM)
- **Setup:** Requires local LiteLLM proxy running
- **Get API Key:** https://aistudio.google.com/apikey
- **Installation:**
  ```bash
  pip install litellm
  ```
- **Start Proxy:**
  ```bash
  export GEMINI_API_KEY="AIza-your-key"
  litellm --config config.yaml --port 4000
  ```
- **Command:** `mc gemini "your prompt"`
- **Full Guide:** See GEMINI-SETUP.md

## 🔐 Security

- API keys stored locally in `~/.mc/config.json`
- Never committed to git
- Not shared across machines
- Use `mc config` to manage keys

## 🛠️ Customization

### Change Tool Name

Edit `install.sh` and `mc` script:

```bash
# In install.sh
TOOL_NAME="mytool"

# In mc script
TOOL_NAME="mytool"
CONFIG_DIR="${MYTOOL_CONFIG_DIR:-$HOME/.mytool}"
```

Then rename files:

```bash
mv mc mytool
mv install.sh install-mytool.sh
```

### Change Default Platform

Edit `~/.mc/config.json`:

```json
{
  "default": "kimi",
  ...
}
```

## 🐛 Troubleshooting

**Command not found:**

```bash
export PATH="$HOME/.local/bin:$PATH"
source ~/.zshrc
```

**Config error:**

```bash
mc config
# Make sure JSON is valid
```

**Claude Code not found:**

```bash
npm install -g @anthropic-ai/claude-code
```

## 📝 Setup for GitHub

1. Create new GitHub repository: `mc`
2. Add these files:
   - `install.sh`
   - `mc` (the main script)
   - `config.json.example`
   - `README.md`
   - `LICENSE` (optional)

3. Update `install.sh`:
   ```bash
   REPO_OWNER="akfajricrt"
   REPO_NAME="mc"
   ```

4. Push to GitHub:
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git remote add origin https://github.com/akfajricrt/mc.git
   git branch -M main
   git push -u origin main
   ```

5. Share installation command:
   ```bash
   curl -fsSL https://raw.githubusercontent.com/akfajricrt/mc/main/install.sh | bash
   ```

## 🎯 Usage Tips

### Alias for Quick Access

Add to `~/.zshrc`:

```bash
alias cc="mc"
alias cc-deep="mc deep"
alias cc-kimi="mc kimi"
```

Then use:

```bash
cc              # Instead of mc
cc-kimi "code"  # Instead of mc kimi "code"
```

### Save Common Prompts

Create shell functions:

```bash
# In ~/.zshrc
function cc-api() {
  mc deep "create a REST API in Go with error handling"
}

function cc-test() {
  mc deep "write comprehensive unit tests"
}
```

Then use:

```bash
cc-api    # Runs predefined prompt
cc-test   # Runs predefined prompt
```

## 📄 License

MIT License (or your preferred license)

## 🙋 Support

Having issues? Check the troubleshooting section or create an issue on GitHub.

---

Made with ❤️ for Claude Code users
