#!/usr/bin/env bash
#
# mc - Claude Code with Multiple Model Support
# 
# Your personal Claude Code tool switcher
# 
# Usage:
#   mc setup          # First-time setup
#   mc                # Interactive mode (default platform)
#   mc kimi           # Switch to Kimi
#   mc deep "code"    # Use DeepSeek with prompt
#

set -euo pipefail

# ============================================================================
# CONFIGURATION - Customize these
# ============================================================================
TOOL_NAME="mc"
AUTHOR="Your Name"
CONFIG_DIR="${MC_CONFIG_DIR:-$HOME/.mc}"
CONFIG_FILE="$CONFIG_DIR/config.json"

# ============================================================================
# Setup
# ============================================================================

mkdir -p "$CONFIG_DIR"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

#==============================================================================
# Helper Functions
#==============================================================================

log_info() {
  echo -e "${BLUE}ℹ${NC} $*"
}

log_success() {
  echo -e "${GREEN}✓${NC} $*"
}

log_warn() {
  echo -e "${YELLOW}⚠${NC} $*"
}

log_error() {
  echo -e "${RED}✗${NC} $*" >&2
}

# Read config value with jq
read_config() {
  local key=$1
  if [ ! -f "$CONFIG_FILE" ]; then
    return 1
  fi
  
  if command -v jq >/dev/null 2>&1; then
    jq -r ".platforms.$key // empty" "$CONFIG_FILE" 2>/dev/null || echo ""
  else
    grep "\"$key\"" "$CONFIG_FILE" | head -1 | cut -d'"' -f4
  fi
}

#==============================================================================
# Setup Function
#==============================================================================

setup_config() {
  echo ""
  echo -e "${PURPLE}╔════════════════════════════════════════════════════════════╗${NC}"
  echo -e "${PURPLE}║          🚀 $TOOL_NAME First-Time Setup                    ║${NC}"
  echo -e "${PURPLE}╚════════════════════════════════════════════════════════════╝${NC}"
  echo ""
  
  # Create default config
  cat > "$CONFIG_FILE" << 'EOFCONFIG'
{
  "default": "deepseek",
  "platforms": {
    "deepseek": {
      "base_url": "https://api.deepseek.com/anthropic",
      "api_key": "",
      "model": "deepseek-v4-pro",
      "small_model": "deepseek-v4-flash"
    },
    "kimi": {
      "base_url": "https://api.moonshot.ai/anthropic",
      "api_key": "",
      "model": "kimi-k2.6",
      "small_model": "kimi-k2.6"
    },
    "openrouter": {
      "base_url": "https://openrouter.ai/api/v1",
      "api_key": "",
      "model": "deepseek/deepseek-chat",
      "small_model": "deepseek/deepseek-chat"
    },
    "gemini": {
      "base_url": "http://127.0.0.1:4000",
      "api_key": "sk-dummy-token",
      "model": "gemini-pro",
      "small_model": "gemini-flash"
    }
  }
}
EOFCONFIG
  
  log_success "Config created: $CONFIG_FILE"
  echo ""
  echo "Available platforms:"
  echo "  1) DeepSeek (deepseek-v4-pro)"
  echo "  2) Kimi (kimi-k2.6)"
  echo "  3) OpenRouter (200+ models)"
  echo "  4) Gemini (via LiteLLM proxy)"
  echo ""
  
  read -p "Select a platform to setup (1-4) [1]: " choice
  choice=${choice:-1}
  
  case $choice in
    1) setup_platform "deepseek" ;;
    2) setup_platform "kimi" ;;
    3) setup_platform "openrouter" ;;
    4) setup_platform "gemini" ;;
    *) log_error "Invalid choice"; exit 1 ;;
  esac
  
  echo ""
  echo -e "${PURPLE}╔════════════════════════════════════════════════════════════╗${NC}"
  echo -e "${PURPLE}║                  ✅ Setup Complete!                        ║${NC}"
  echo -e "${PURPLE}╚════════════════════════════════════════════════════════════╝${NC}"
  echo ""
  echo "Next steps:"
  echo "  • Edit config: $TOOL_NAME config"
  echo "  • View platforms: $TOOL_NAME list"
  echo "  • Start using: $TOOL_NAME"
  echo ""
}

setup_platform() {
  local platform=$1
  
  case $platform in
    deepseek)
      log_info "DeepSeek API Key"
      echo "   Get it at: https://platform.deepseek.com"
      read -sp "API Key: " api_key
      echo ""
      ;;
    kimi)
      log_info "Kimi API Key"
      echo "   Get it at: https://platform.moonshot.cn"
      read -sp "API Key: " api_key
      echo ""
      ;;
    openrouter)
      log_info "OpenRouter API Key"
      echo "   Get it at: https://openrouter.ai/keys"
      read -sp "API Key: " api_key
      echo ""
      ;;
    gemini)
      echo ""
      echo "═══════════════════════════════════════════════════════════"
      echo "  Gemini Setup (via LiteLLM Proxy)"
      echo "═══════════════════════════════════════════════════════════"
      echo ""
      echo "Gemini requires local LiteLLM proxy. Setup steps:"
      echo ""
      echo "1️⃣  Install LiteLLM:"
      echo "   pip install litellm"
      echo ""
      echo "2️⃣  Get Gemini API Key:"
      echo "   Visit: https://aistudio.google.com/apikey"
      echo ""
      echo "3️⃣  Create config.yaml in ~/gemini-litellm/:"
      echo "   cat > ~/gemini-litellm/config.yaml << 'EOF'"
      echo "model_list:"
      echo "  - model_name: gemini-pro"
      echo "    litellm_params:"
      echo "      model: gemini/gemini-1.5-pro-exp"
      echo "      api_key: os.environ/GEMINI_API_KEY"
      echo "  - model_name: gemini-flash"
      echo "    litellm_params:"
      echo "      model: gemini/gemini-1.5-flash-exp"
      echo "      api_key: os.environ/GEMINI_API_KEY"
      echo "EOF"
      echo ""
      echo "4️⃣  Start LiteLLM in a separate terminal:"
      echo "   export GEMINI_API_KEY='AIza-your-key-here'"
      echo "   cd ~/gemini-litellm"
      echo "   litellm --config config.yaml --port 4000"
      echo ""
      echo "5️⃣  Keep that terminal running, then use mc!"
      echo ""
      echo "ℹ️  LiteLLM must be running before using 'mc gemini'"
      echo ""
      ;;
  esac
  
  if [ -n "$api_key" ]; then
    log_success "$platform API key saved"
  fi
}

# List platforms
list_platforms() {
  echo ""
  echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
  echo -e "${BLUE}║              📋 Configured Platforms                       ║${NC}"
  echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
  echo ""
  
  if [ ! -f "$CONFIG_FILE" ]; then
    log_warn "Config not found. Run: $TOOL_NAME setup"
    exit 1
  fi
  
  if command -v jq >/dev/null 2>&1; then
    jq -r '.platforms | keys[]' "$CONFIG_FILE" | while read -r platform; do
      model=$(jq -r ".platforms.\"$platform\".model" "$CONFIG_FILE")
      echo "  • $platform: $model"
    done
  else
    cat "$CONFIG_FILE"
  fi
  echo ""
}

# Export env vars for platform
export_platform_vars() {
  local platform=$1
  
  if [ ! -f "$CONFIG_FILE" ]; then
    log_error "Config not found. Run: $TOOL_NAME setup"
    exit 1
  fi
  
  if command -v jq >/dev/null 2>&1; then
    local base_url=$(jq -r ".platforms.\"$platform\".base_url" "$CONFIG_FILE")
    local api_key=$(jq -r ".platforms.\"$platform\".api_key" "$CONFIG_FILE")
    local model=$(jq -r ".platforms.\"$platform\".model" "$CONFIG_FILE")
    local small_model=$(jq -r ".platforms.\"$platform\".small_model" "$CONFIG_FILE")
    
    if [ "$api_key" = "null" ] || [ -z "$api_key" ]; then
      log_error "API key not configured for $platform"
      log_info "Run: $TOOL_NAME config"
      exit 1
    fi
    
    export ANTHROPIC_BASE_URL="$base_url"
    export ANTHROPIC_AUTH_TOKEN="$api_key"
    export ANTHROPIC_MODEL="$model"
    export ANTHROPIC_DEFAULT_HAIKU_MODEL="$small_model"
    
    echo -e "${GREEN}✓${NC} Using $platform"
  fi
}

# Show help
show_help() {
  echo ""
  echo -e "${PURPLE}$TOOL_NAME${NC} - Claude Code with Multiple Model Support"
  echo ""
  echo "Usage:"
  echo "  $TOOL_NAME [COMMAND] [OPTIONS]"
  echo ""
  echo "Commands:"
  echo "  setup             First-time setup & configuration"
  echo "  list              List all configured platforms"
  echo "  config            Edit configuration file"
  echo "  <platform>        Use specific platform (interactive)"
  echo "  <platform> <cmd>  Use platform with command"
  echo "  help              Show this help message"
  echo ""
  echo "Examples:"
  echo "  $TOOL_NAME              # Interactive (default)"
  echo "  $TOOL_NAME kimi         # Use Kimi"
  echo "  $TOOL_NAME deep 'code'  # DeepSeek with prompt"
  echo "  $TOOL_NAME gemini       # Use Gemini (requires LiteLLM)"
  echo ""
  echo "Platforms:"
  echo "  deep, deepseek   - DeepSeek (v4-pro)"
  echo "  kimi             - Kimi (k2.6)"
  echo "  or, openrouter   - OpenRouter (200+ models)"
  echo "  gemini           - Google Gemini (via LiteLLM proxy)"
  echo ""
  echo "Gemini Setup:"
  echo "  1. pip install litellm"
  echo "  2. Get API key from: https://aistudio.google.com/apikey"
  echo "  3. Create config: ~/gemini-litellm/config.yaml"
  echo "  4. Start proxy: litellm --config config.yaml --port 4000"
  echo "  5. Run: $TOOL_NAME gemini"
  echo ""
}

#==============================================================================
# Main Logic
#==============================================================================

main() {
  # Check if Claude Code is installed
  if ! command -v claude >/dev/null 2>&1; then
    log_error "Claude Code not found"
    echo "Install it with:"
    echo "  npm install -g @anthropic-ai/claude-code"
    exit 1
  fi
  
  # No arguments = interactive with default
  if [ $# -eq 0 ]; then
    if [ ! -f "$CONFIG_FILE" ]; then
      setup_config
      exit 0
    fi
    
    local default=$(jq -r '.default' "$CONFIG_FILE" 2>/dev/null || echo "deepseek")
    log_info "Using default platform: $default"
    export_platform_vars "$default"
    exec claude
  fi
  
  local cmd=$1
  shift
  
  case "$cmd" in
    setup)
      setup_config
      ;;
    list)
      list_platforms
      ;;
    config)
      if [ -z "${EDITOR:-}" ]; then
        EDITOR="nano"
      fi
      log_info "Opening config in $EDITOR..."
      $EDITOR "$CONFIG_FILE"
      ;;
    help|--help|-h)
      show_help
      ;;
    
    # Platform shortcuts
    deep|deepseek)
      if [ ! -f "$CONFIG_FILE" ]; then
        setup_config
      fi
      export_platform_vars "deepseek"
      if [ $# -gt 0 ]; then
        exec claude "$@"
      else
        exec claude
      fi
      ;;
    
    kimi)
      if [ ! -f "$CONFIG_FILE" ]; then
        setup_config
      fi
      export_platform_vars "kimi"
      if [ $# -gt 0 ]; then
        exec claude "$@"
      else
        exec claude
      fi
      ;;
    
    or|openrouter)
      if [ ! -f "$CONFIG_FILE" ]; then
        setup_config
      fi
      export_platform_vars "openrouter"
      if [ $# -gt 0 ]; then
        exec claude "$@"
      else
        exec claude
      fi
      ;;
    
    gemini)
      if [ ! -f "$CONFIG_FILE" ]; then
        setup_config
      fi
      log_info "Checking if LiteLLM is running on port 4000..."
      if ! nc -z 127.0.0.1 4000 2>/dev/null; then
        log_warn "LiteLLM proxy not running on port 4000"
        echo ""
        echo "Start LiteLLM in another terminal:"
        echo "  export GEMINI_API_KEY='AIza-your-key'"
        echo "  litellm --config config.yaml --port 4000"
        echo ""
        exit 1
      fi
      export_platform_vars "gemini"
      if [ $# -gt 0 ]; then
        exec claude "$@"
      else
        exec claude
      fi
      ;;
    
    *)
      log_error "Unknown command: $cmd"
      show_help
      exit 1
      ;;
  esac
}

main "$@"
