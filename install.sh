#!/bin/bash
# Git Security Hooks - Installer
# https://github.com/wfried/git-security-hooks
#
# Usage:
#   curl -sSL https://raw.githubusercontent.com/wfried/git-security-hooks/main/install.sh | bash
#   OR
#   ./install.sh

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

REPO_URL="https://raw.githubusercontent.com/wfried/git-security-hooks/main"

echo "🔧 Git Security Hooks Installer"
echo ""

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo -e "${RED}Error: Not a git repository.${NC}"
    echo "Please run this from the root of your git repository."
    exit 1
fi

# Create hooks directory if it doesn't exist
mkdir -p .git/hooks

# Check for existing pre-commit hook
if [ -f ".git/hooks/pre-commit" ]; then
    echo -e "${YELLOW}Existing pre-commit hook found.${NC}"
    BACKUP_NAME=".git/hooks/pre-commit.backup.$(date +%Y%m%d%H%M%S)"
    cp .git/hooks/pre-commit "$BACKUP_NAME"
    echo "  → Backed up to: $BACKUP_NAME"
fi

# Determine install source
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/hooks/pre-commit" ]; then
    # Local install
    echo "Installing from local source..."
    cp "$SCRIPT_DIR/hooks/pre-commit" .git/hooks/pre-commit
else
    # Remote install
    echo "Downloading pre-commit hook..."
    if command -v curl &> /dev/null; then
        curl -sSL "$REPO_URL/hooks/pre-commit" -o .git/hooks/pre-commit
    elif command -v wget &> /dev/null; then
        wget -q "$REPO_URL/hooks/pre-commit" -O .git/hooks/pre-commit
    else
        echo -e "${RED}Error: Neither curl nor wget found.${NC}"
        exit 1
    fi
fi

# Make executable
chmod +x .git/hooks/pre-commit

echo ""
echo -e "${GREEN}✓ Git security hooks installed successfully!${NC}"
echo ""
echo "The pre-commit hook will now check for:"
echo "  • Build artifacts (.aws-sam, node_modules, etc.)"
echo "  • Local file paths (/Users/*, /home/*, etc.)"
echo "  • AWS credentials"
echo "  • API keys and secrets"
echo "  • Private keys"
echo "  • Secret files (.env, *.pem, etc.)"
echo "  • URLs with embedded credentials"
echo ""
echo "To uninstall: rm .git/hooks/pre-commit"
