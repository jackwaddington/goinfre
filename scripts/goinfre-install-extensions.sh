#!/bin/bash

# goinfre-dev: Install VS Code extensions from manifest
# Run this manually when you want to install extensions

MANIFEST_FILE=~/.goinfre-dev/vscode-extensions.txt

if [ ! -f "$MANIFEST_FILE" ]; then
    echo "❌ No extension manifest found at: $MANIFEST_FILE"
    echo "Save your extensions first with:"
    echo "  goinfre-save-extensions"
    exit 1
fi

EXTENSION_COUNT=$(wc -l < "$MANIFEST_FILE")
echo "📦 Installing $EXTENSION_COUNT VS Code extensions..."
echo ""

INSTALLED=0
FAILED=0

while IFS= read -r extension; do
    if [ -z "$extension" ]; then
        continue
    fi

    echo "⏳ Installing: $extension"
    if code --install-extension "$extension" --force > /dev/null 2>&1; then
        INSTALLED=$((INSTALLED + 1))
        echo "✓ Installed: $extension"
    else
        FAILED=$((FAILED + 1))
        echo "❌ Failed: $extension"
    fi
    echo ""
done < "$MANIFEST_FILE"

echo "=========================================="
echo "Installation complete!"
echo "✓ Installed: $INSTALLED"
if [ $FAILED -gt 0 ]; then
    echo "❌ Failed: $FAILED"
fi
echo "=========================================="
echo ""
echo "Restart VS Code for extensions to fully activate."
