#!/bin/bash

# goinfre-dev: Disk Space Report
# Analyze what's using space on your network drive

set -e

echo "=========================================="
echo "  goinfre-dev: Disk Space Report"
echo "=========================================="
echo ""

# Overall disk usage
echo "📊 Overall Disk Usage:"
df -h ~ | tail -1 | awk '{printf "   Used: %s / %s (%s full)\n   Free: %s\n", $3, $2, $5, $4}'
echo ""

# Home directory breakdown
echo "📁 Top-level directories in ~/ :"
echo ""
du -sh ~/* ~/.* 2>/dev/null | sort -h | tail -20 | awk '{
    size = $1
    path = $2
    gsub(/\/home\/[^\/]+\//, "~/", path)
    printf "   %-8s  %s\n", size, path
}'
echo ""

# Largest directories anywhere
echo "🔍 Largest directories (top 15):"
echo ""
echo "   Scanning... this may take 30 seconds..."
du -ah ~ 2>/dev/null | sort -h | tail -15 | awk '{
    size = $1
    path = $2
    gsub(/\/home\/[^\/]+\//, "~/", path)
    printf "   %-8s  %s\n", size, path
}'
echo ""

# Check for common space hogs
echo "⚠️  Common Space Hogs:"
echo ""

# node_modules
NODE_MODULES_COUNT=$(find ~ -name "node_modules" -type d 2>/dev/null | wc -l)
if [ $NODE_MODULES_COUNT -gt 0 ]; then
    echo "   node_modules directories found: $NODE_MODULES_COUNT"
    find ~ -name "node_modules" -type d -exec du -sh {} \; 2>/dev/null | sort -h | tail -10 | awk '{
        size = $1
        path = $2
        gsub(/\/home\/[^\/]+\//, "~/", path)
        printf "      %-8s  %s\n", size, path
    }'
else
    echo "   ✓ No node_modules found"
fi
echo ""

# Cache directories
if [ -d ~/.cache ]; then
    CACHE_SIZE=$(du -sh ~/.cache 2>/dev/null | cut -f1)
    echo "   ~/.cache: $CACHE_SIZE"
    du -sh ~/.cache/* 2>/dev/null | sort -h | tail -5 | awk '{
        size = $1
        path = $2
        gsub(/\/home\/[^\/]+\//, "~/", path)
        printf "      %-8s  %s\n", size, path
    }'
else
    echo "   ✓ No ~/.cache directory"
fi
echo ""

# .local
if [ -d ~/.local/share ]; then
    LOCAL_SIZE=$(du -sh ~/.local 2>/dev/null | cut -f1)
    echo "   ~/.local: $LOCAL_SIZE"
    du -sh ~/.local/share/* 2>/dev/null | sort -h | tail -5 | awk '{
        size = $1
        path = $2
        gsub(/\/home\/[^\/]+\//, "~/", path)
        printf "      %-8s  %s\n", size, path
    }'
else
    echo "   ✓ No significant ~/.local data"
fi
echo ""

# .var (flatpak)
if [ -d ~/.var/app ]; then
    VAR_SIZE=$(du -sh ~/.var 2>/dev/null | cut -f1)
    echo "   ~/.var (flatpak): $VAR_SIZE"
    du -sh ~/.var/app/* 2>/dev/null | sort -h | tail -5 | awk '{
        size = $1
        path = $2
        gsub(/\/home\/[^\/]+\//, "~/", path)
        printf "      %-8s  %s\n", size, path
    }'
else
    echo "   ✓ No flatpak data"
fi
echo ""

# Backup directories
BACKUP_SIZE=0
if [ -d ~/.goinfre-dev-backup ]; then
    BACKUP_SIZE=$(du -sh ~/.goinfre-dev-backup 2>/dev/null | cut -f1)
    echo "   📦 Backups: $BACKUP_SIZE"
    echo "      ~/.goinfre-dev-backup (can be deleted once you're confident)"
fi
echo ""

# Hidden files
echo "💡 Tips to free space:"
echo ""
if [ $NODE_MODULES_COUNT -gt 0 ]; then
    echo "   • Delete node_modules (run 'npm install' when needed):"
    echo "     find ~/github -name 'node_modules' -type d -exec rm -rf {} +"
    echo ""
fi
if [ -d ~/.cache ] && [ "$(du -s ~/.cache 2>/dev/null | cut -f1)" -gt 100000 ]; then
    echo "   • Clear cache directories (safe to delete):"
    echo "     rm -rf ~/.cache/*"
    echo ""
fi
if [ -d ~/.goinfre-dev-backup ]; then
    echo "   • Remove backup (once VS Code works well):"
    echo "     rm -rf ~/.goinfre-dev-backup"
    echo ""
fi
if [ -d ~/.local/share/Trash ]; then
    TRASH_SIZE=$(du -sh ~/.local/share/Trash 2>/dev/null | cut -f1 || echo "0")
    if [ "$TRASH_SIZE" != "0" ]; then
        echo "   • Empty trash:"
        echo "     rm -rf ~/.local/share/Trash/*"
        echo ""
    fi
fi

echo "=========================================="
echo ""
echo "💾 Current status:"
df -h ~ | tail -1 | awk '{printf "   %s free of %s (%s used)\n", $4, $2, $5}'
echo ""
echo "Run 'goinfre-disk-report' anytime to check again!"
echo ""
