#!/usr/bin/env bash
#
# mc - Uninstaller with auto PATH cleanup
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

# ============================================================================
# 1. Remove Executable
# ============================================================================

if [ ! -f "$BIN_DIR/$TOOL_NAME" ]; then
  echo -e "${YELLOW}⚠${NC}  $TOOL_NAME not found in $BIN_DIR"
  echo "   Maybe not installed or installed in different location?"
  echo ""
else
  echo -e "${BLUE}Removing${NC} $BIN_DIR/$TOOL_NAME"
  rm -f "$BIN_DIR/$TOOL_NAME"
  ((DELETED_COUNT++))
  echo -e "${GREEN}✓${NC} Executable removed"
fi

echo ""

# ============================================================================
# 2. Remove Config (Ask User)
# ============================================================================

echo "Config directory: $CONFIG_DIR"
echo ""

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
  fi
fi

echo ""

# ============================================================================
# 3. AUTO-REMOVE PATH (NEW!)
# ============================================================================

echo -e "${BLUE}Cleaning up PATH entries...${NC}"
PATHS_REMOVED=0

# Clean ~/.zshrc
if [ -f "$HOME/.zshrc" ]; then
  if grep -q "\.local/bin\|$TOOL_NAME" "$HOME/.zshrc"; then
    echo -e "${BLUE}Cleaning${NC} ~/.zshrc"
    
    # Remove lines with .local/bin PATH export
    grep -v "\.local/bin\|$TOOL_NAME.*Added by installer" "$HOME/.zshrc" > "$HOME/.zshrc.tmp"
    mv "$HOME/.zshrc.tmp" "$HOME/.zshrc"
    
    echo -e "${GREEN}✓${NC} PATH cleaned from ~/.zshrc"
    ((PATHS_REMOVED++))
  fi
fi

# Clean ~/.bashrc
if [ -f "$HOME/.bashrc" ]; then
  if grep -q "\.local/bin\|$TOOL_NAME" "$HOME/.bashrc"; then
    echo -e "${BLUE}Cleaning${NC} ~/.bashrc"
    
    # Remove lines with .local/bin PATH export
    grep -v "\.local/bin\|$TOOL_NAME.*Added by installer" "$HOME/.bashrc" > "$HOME/.bashrc.tmp"
    mv "$HOME/.bashrc.tmp" "$HOME/.bashrc"
    
    echo -e "${GREEN}✓${NC} PATH cleaned from ~/.bashrc"
    ((PATHS_REMOVED++))
  fi
fi

if [ $PATHS_REMOVED -eq 0 ]; then
  echo -e "${YELLOW}⚠${NC}  No PATH entries found to clean"
else
  ((DELETED_COUNT++))
fi

echo ""
echo "═══════════════════════════════════════════════════════════════"

# ============================================================================
# Summary
# ============================================================================

if [ $DELETED_COUNT -gt 0 ]; then
  echo -e "${GREEN}✅ $TOOL_NAME uninstalled successfully!${NC}"
else
  echo -e "${YELLOW}⚠${NC}  Nothing removed"
fi

echo ""
echo "Summary:"
echo "  - Executable: $([ ! -f "$BIN_DIR/$TOOL_NAME" ] && echo 'Removed ✓' || echo 'Not found')"
echo "  - Config: $([ ! -d "$CONFIG_DIR" ] && echo 'Removed ✓' || echo 'Kept')"
echo "  - PATH entries: $([ $PATHS_REMOVED -gt 0 ] && echo "Cleaned from $PATHS_REMOVED file(s) ✓" || echo 'None found')"
echo ""

# ============================================================================
# Next Steps
# ============================================================================

echo "📋 Next steps:"
echo ""
echo "  1. Reload shell:"
echo "     ${YELLOW}source ~/.zshrc${NC}  (or source ~/.bashrc)"
echo ""
echo "  2. Or open a new terminal"
echo ""
echo "  3. Verify uninstalled:"
echo "     ${YELLOW}which mc${NC}"
echo "     (should show: command not found)"
echo ""
echo "Thank you for using $TOOL_NAME! 👋"
echo ""