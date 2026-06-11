#!/usr/bin/env bash
#
# mc - Claude Code with multiple model support
# Custom installer script
# 
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/akfajricrt/mc/main/install.sh | bash
#
set -euo pipefail

# ============================================================================
# CUSTOMIZE THESE VALUES
# ============================================================================
TOOL_NAME="mc"                    # Change this to your tool name
REPO_OWNER="akfajricrt"         # Your GitHub username
REPO_NAME="mc"                    # Your repository name
REPO_RAW="https://raw.githubusercontent.com/$REPO_OWNER/$REPO_NAME/main"

# ============================================================================
# Installation
# ============================================================================

BIN_DIR="${MC_BIN_DIR:-$HOME/.local/bin}"
CONFIG_DIR="$HOME/.mc"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}"
echo "╔════════════════════════════════════════════════════════════╗"
echo "║           🚀 Installing $TOOL_NAME                        ║"
echo "║     Claude Code with Multiple Model Support                ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo ""

# Create directories
mkdir -p "$BIN_DIR"
mkdir -p "$CONFIG_DIR"

echo "📁 Directories:"
echo "   Bin:    $BIN_DIR"
echo "   Config: $CONFIG_DIR"
echo ""

# Download main script
echo "⬇️  Downloading $TOOL_NAME..."
if command -v curl >/dev/null 2>&1; then
  curl -fsSL "$REPO_RAW/$TOOL_NAME" -o "$BIN_DIR/$TOOL_NAME" || {
    echo -e "${RED}❌ Failed to download from GitHub${NC}" >&2
    echo "   Make sure the script exists at: $REPO_RAW/$TOOL_NAME"
    exit 1
  }
elif command -v wget >/dev/null 2>&1; then
  wget -qO "$BIN_DIR/$TOOL_NAME" "$REPO_RAW/$TOOL_NAME" || {
    echo -e "${RED}❌ Failed to download from GitHub${NC}" >&2
    exit 1
  }
else
  echo -e "${RED}❌ Need curl or wget${NC}" >&2
  exit 1
fi

chmod +x "$BIN_DIR/$TOOL_NAME"
echo -e "${GREEN}✓${NC} Downloaded: $BIN_DIR/$TOOL_NAME"
echo ""

# Create config template if not exists
if [ ! -f "$CONFIG_DIR/config.json" ]; then
  echo "📝 Creating configuration template..."
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$REPO_RAW/config.json.example" -o "$CONFIG_DIR/config.json" 2>/dev/null || true
  elif command -v wget >/dev/null 2>&1; then
    wget -qO "$CONFIG_DIR/config.json" "$REPO_RAW/config.json.example" 2>/dev/null || true
  fi
  
  if [ ! -f "$CONFIG_DIR/config.json" ]; then
    # Fallback: create minimal config
    cat > "$CONFIG_DIR/config.json" << 'EOFCONFIG'
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
    }
  }
}
EOFCONFIG
  fi
  echo -e "${GREEN}✓${NC} Config created: $CONFIG_DIR/config.json"
fi

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo -e "${GREEN}✅ Installation Complete!${NC}"
echo "═══════════════════════════════════════════════════════════════"
echo ""

# Detect shell profile file
detect_shell_profile() {
  local shell_name
  shell_name="$(basename "${SHELL:-}")"
  if [ "$shell_name" = "zsh" ] || [ -n "${ZSH_VERSION:-}" ]; then
    echo "$HOME/.zshrc"
  elif [ "$shell_name" = "bash" ] || [ -n "${BASH_VERSION:-}" ]; then
    if [ "$(uname)" = "Darwin" ]; then
      echo "$HOME/.bash_profile"
    else
      echo "$HOME/.bashrc"
    fi
  else
    echo "$HOME/.profile"
  fi
}

PATH_LINE="export PATH=\"$BIN_DIR:\$PATH\""

# Check PATH and auto-inject into shell profile if needed
case ":$PATH:" in
  *":$BIN_DIR:"*)
    echo -e "${GREEN}✓${NC} $BIN_DIR is already in your PATH"
    echo ""
    echo "Next steps:"
    echo "  1. Run: $TOOL_NAME setup"
    echo "  2. Follow the interactive setup"
    echo "  3. Start using: $TOOL_NAME"
    ;;
  *)
    SHELL_PROFILE="$(detect_shell_profile)"

    if [ -f "$SHELL_PROFILE" ] && grep -qF "$BIN_DIR" "$SHELL_PROFILE" 2>/dev/null; then
      echo -e "${GREEN}✓${NC} $BIN_DIR already in $SHELL_PROFILE (reload required)"
    else
      echo "" >> "$SHELL_PROFILE"
      echo "# Added by $TOOL_NAME installer" >> "$SHELL_PROFILE"
      echo "$PATH_LINE" >> "$SHELL_PROFILE"
      echo -e "${GREEN}✓${NC} PATH ditambahkan ke $SHELL_PROFILE"
    fi

    echo ""
    echo "Jalankan salah satu perintah berikut untuk mengaktifkan:"
    echo ""
    echo -e "  ${BLUE}source $SHELL_PROFILE${NC}"
    echo ""
    echo "Atau buka terminal baru, lalu jalankan:"
    echo "  $TOOL_NAME setup"
    ;;
esac

echo ""
echo "📚 Documentation:"
echo "  GitHub: https://github.com/$REPO_OWNER/$REPO_NAME"
echo "  Help:   $TOOL_NAME help"
echo ""