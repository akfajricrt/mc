#!/usr/bin/env bash
#
# mc - Uninstaller
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/yourusername/mc/main/uninstall.sh | bash
#
set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Directories
TOOL_NAME="mc"
BIN_DIR="${MC_BIN_DIR:-$HOME/.local/bin}"
CONFIG_DIR="$HOME/.mc"

echo -e "${BLUE}"
echo "╔════════════════════════════════════════════════════════════╗"
echo "║        🗑️  Uninstalling $TOOL_NAME                         ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo ""

# Track what gets deleted
DELETED_COUNT=0

# Check if installed
if [ ! -f "$BIN_DIR/$TOOL_NAME" ]; then
  echo -e "${YELLOW}⚠${NC}  $TOOL_NAME not found in $BIN_DIR"
  echo "   Maybe not installed or installed in different location?"
  echo ""
else
  # Remove executable
  echo -e "${BLUE}Removing${NC} $BIN_DIR/$TOOL_NAME"
  rm -f "$BIN_DIR/$TOOL_NAME"
  ((DELETED_COUNT++))
  echo -e "${GREEN}✓${NC} Executable removed"
fi

echo ""
echo "Config directory: $CONFIG_DIR"
echo ""

# Ask about config
if [ -d "$CONFIG_DIR" ]; then
  echo -e "${YELLOW}ℹ${NC}  Found config directory with your settings"
  
  read -p "Remove config directory and all settings? (y/N): " remove_config
  
  if [[ "$remove_config" =~ ^[Yy]$ ]]; then
    echo -e "${BLUE}Removing${NC} $CONFIG_DIR"
    rm -rf "$CONFIG_DIR"
    ((DELETED_COUNT++))
    echo -e "${GREEN}✓${NC} Config directory removed"
  else
    echo -e "${YELLOW}⚠${NC}  Config directory kept at: $CONFIG_DIR"
    echo "   You can remove it manually: rm -rf $CONFIG_DIR"
  fi
fi

echo ""
echo "═══════════════════════════════════════════════════════════════"

if [ $DELETED_COUNT -gt 0 ]; then
  echo -e "${GREEN}✅ $TOOL_NAME uninstalled successfully!${NC}"
else
  echo -e "${YELLOW}⚠${NC}  Nothing removed"
fi

echo ""
echo "Summary:"
echo "  - Executable: Removed"
echo "  - Config: $([ -d "$CONFIG_DIR" ] && echo 'Kept (can be removed manually)' || echo 'Removed')"
echo ""

# Remove from PATH - instructions only
if grep -q "\.local/bin" "$HOME/.zshrc" 2>/dev/null || \
   grep -q "\.local/bin" "$HOME/.bashrc" 2>/dev/null; then
  echo -e "${BLUE}Optional:${NC} Remove PATH export from shell config"
  echo ""
  echo "  Edit ~/.zshrc or ~/.bashrc and remove:"
  echo "    export PATH=\"\$HOME/.local/bin:\$PATH\""
  echo ""
  echo "  Then run: source ~/.zshrc"
  echo ""
fi

echo "Thank you for using $TOOL_NAME! 👋"
echo ""
