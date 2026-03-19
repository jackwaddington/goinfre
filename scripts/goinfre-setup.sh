#!/bin/bash

# goinfre-dev: Automatic setup on login
# This script runs automatically to set up VS Code in goinfre

set -e  # Exit on error

GOINFRE_DIR=~/goinfre/vscode-data
VSCODE_DIR=~/.var/app/com.visualstudio.code
MANIFEST_DIR=~/.goinfre-dev

# Check if goinfre is available
if [ ! -d ~/goinfre ]; then
    echo "⚠️  goinfre directory not available"
    exit 0  # Silent exit, not a critical error
fi

# Create goinfre directory structure if needed
if [ ! -d "$GOINFRE_DIR" ]; then
    echo "📁 Creating VS Code directory in goinfre..."
    mkdir -p "$GOINFRE_DIR"
fi

# Check if VS Code directory exists on network drive
if [ -d "$VSCODE_DIR" ] && [ ! -L "$VSCODE_DIR" ]; then
    # It's a real directory, not a symlink - VS Code data is on network drive
    echo "🔄 Moving VS Code data to goinfre..."
    mv "$VSCODE_DIR" "$GOINFRE_DIR/"
    ln -s "$GOINFRE_DIR/com.visualstudio.code" "$VSCODE_DIR"
    echo "✓ VS Code data moved to goinfre"
elif [ ! -e "$VSCODE_DIR" ]; then
    # Directory doesn't exist at all - create symlink to empty goinfre location
    echo "🔗 Creating VS Code symlink..."

    # Check if we need to create the target directory
    if [ ! -d "$GOINFRE_DIR/com.visualstudio.code" ]; then
        mkdir -p "$GOINFRE_DIR/com.visualstudio.code"
    fi

    ln -s "$GOINFRE_DIR/com.visualstudio.code" "$VSCODE_DIR"
    echo "✓ Symlink created"

    # Check if we should install extensions
    if [ -f "$MANIFEST_DIR/vscode-extensions.txt" ]; then
        echo ""
        echo "📦 Extension list found!"
        echo "To install your extensions, run:"
        echo "  goinfre-install-extensions"
        echo ""
    fi
elif [ -L "$VSCODE_DIR" ]; then
    # Already a symlink - all good!
    echo "✓ VS Code already using goinfre"
fi

# Show disk usage
echo ""
echo "💾 Disk space: $(df -h ~ | tail -1 | awk '{print $5 " used (" $3 " / " $2 ")"}')"
