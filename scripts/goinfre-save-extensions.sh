#!/bin/bash

# goinfre-dev: Save VS Code extension list
# Run this before logout or when you add new extensions

MANIFEST_DIR=~/.goinfre-dev
MANIFEST_FILE="$MANIFEST_DIR/vscode-extensions.txt"

mkdir -p "$MANIFEST_DIR"

echo "💾 Saving VS Code extension list..."
code --list-extensions > "$MANIFEST_FILE"

EXTENSION_COUNT=$(wc -l < "$MANIFEST_FILE")

echo "✓ Saved $EXTENSION_COUNT extensions to:"
echo "  $MANIFEST_FILE"
echo ""
echo "This file is on your network drive and will persist after logout."
