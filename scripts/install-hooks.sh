#!/bin/bash

# goinfre-dev: Install shell hooks for automatic setup
# This adds the goinfre-setup script to run on shell startup

SCRIPTS_DIR=~/github/goinfre_dev/scripts

# Detect shell
if [ -n "$ZSH_VERSION" ]; then
    SHELL_RC=~/.zshrc
    SHELL_NAME="zsh"
elif [ -n "$BASH_VERSION" ]; then
    SHELL_RC=~/.bashrc
    SHELL_NAME="bash"
else
    echo "❌ Unknown shell. Please add manually to your shell RC file."
    exit 1
fi

echo "Installing goinfre-dev hooks for $SHELL_NAME..."
echo ""

# Check if already installed
if grep -q "goinfre-dev" "$SHELL_RC" 2>/dev/null; then
    echo "⚠️  goinfre-dev hooks already installed in $SHELL_RC"
    echo "To reinstall, remove the goinfre-dev section and run this again."
    exit 0
fi

# Add hooks to shell RC
cat >> "$SHELL_RC" << 'EOF'

# === goinfre-dev: Automatic VS Code setup ===
if [ -f ~/github/goinfre_dev/scripts/goinfre-setup.sh ]; then
    ~/github/goinfre_dev/scripts/goinfre-setup.sh
fi

# goinfre-dev aliases
alias goinfre-setup='~/github/goinfre_dev/scripts/goinfre-setup.sh'
alias goinfre-install-extensions='~/github/goinfre_dev/scripts/goinfre-install-extensions.sh'
alias goinfre-save-extensions='~/github/goinfre_dev/scripts/goinfre-save-extensions.sh'
alias goinfre-disk-report='~/github/goinfre_dev/scripts/goinfre-disk-report.sh'
# === end goinfre-dev ===

EOF

echo "✓ Hooks installed in $SHELL_RC"
echo ""
echo "Aliases added:"
echo "  goinfre-setup              - Manually run setup"
echo "  goinfre-install-extensions - Install VS Code extensions"
echo "  goinfre-save-extensions    - Save current extensions"
echo "  goinfre-disk-report        - Analyze disk space usage"
echo ""
echo "⚠️  IMPORTANT: Restart your shell or run:"
echo "  source $SHELL_RC"
echo ""
echo "The setup will now run automatically on every shell startup!"
