#!/bin/bash

# goinfre-dev: Complete VS Code symlink setup
# Run this script AFTER closing VS Code

set -e  # Exit on error

echo "==========================================="
echo "goinfre-dev: Completing VS Code Setup"
echo "==========================================="
echo ""

# Check if VS Code is still running
if ps aux | grep -v grep | grep -q "com.visualstudio.code"; then
    echo "❌ ERROR: VS Code is still running!"
    echo "Please close VS Code completely and run this script again."
    exit 1
fi

echo "✓ VS Code is not running"
echo ""

# Verify data is in goinfre
if [ ! -d ~/goinfre/vscode-data/com.visualstudio.code ]; then
    echo "❌ ERROR: VS Code data not found in goinfre!"
    echo "Data should be at: ~/goinfre/vscode-data/com.visualstudio.code"
    exit 1
fi

echo "✓ VS Code data found in goinfre (1.9GB)"
echo ""

# Remove old directory
echo "Removing old VS Code directory from network drive..."
rm -rf ~/.var/app/com.visualstudio.code
echo "✓ Old directory removed"
echo ""

# Create symlink
echo "Creating symlink..."
ln -s ~/goinfre/vscode-data/com.visualstudio.code ~/.var/app/com.visualstudio.code
echo "✓ Symlink created"
echo ""

# Verify symlink
if [ -L ~/.var/app/com.visualstudio.code ]; then
    echo "✓ Symlink verified!"
    echo ""
    echo "Symlink points to:"
    readlink ~/.var/app/com.visualstudio.code
    echo ""
else
    echo "❌ ERROR: Symlink creation failed!"
    exit 1
fi

# Check disk space
echo "==========================================="
echo "Disk Space Summary:"
echo "==========================================="
df -h ~ | tail -1
echo ""

echo "🎉 SUCCESS! VS Code is now using goinfre!"
echo ""
echo "Next steps:"
echo "1. Open VS Code"
echo "2. Verify all your extensions and settings are still there"
echo "3. If everything works, you just freed 1.9GB on your network drive!"
echo ""
echo "To rollback if needed:"
echo "  rm ~/.var/app/com.visualstudio.code"
echo "  mv ~/.goinfre-dev-backup/vscode-backup-* ~/.var/app/com.visualstudio.code"
echo ""
