# goinfre-dev

> **Free 1GB+ on your 10GB drive. Automatically.**

CLI toolkit for Hive/42 students to manage disk space using the resource of goinfre.

---

## Quick Install

```bash
# Clone the repo
git clone https://github.com/YOUR-USERNAME/goinfre-dev ~/github/goinfre_dev

# Install
~/github/goinfre_dev/scripts/install-hooks.sh
source ~/.zshrc
```

Done! VS Code data is now in goinfre. Extensions will auto-reinstall on next login.

---

## Features

### 1. **Automatic VS Code Management**
- Stores VS Code data in goinfre (not your 10GB drive)
- Creates symlinks so VS Code works normally
- Saves extension list for switching machines
- Data persists on same machine, reinstalls on different machines

### 2. **Disk Space Analyzer**
```
📊 Overall Disk Usage:
   Used: 4.8G / 9.4G (51% full)
   Free: 4.6G

📁 Top space hogs:
   622M      ~/.cache/ms-playwright
   438M      ~/portfolio/node_modules
   327M      ~/.local/share/pnpm
```
Run `goinfre-disk-report` anytime to see what's eating your space.

### 3. **One Command, Many Solutions**
```bash
goinfre-disk-report            # Analyze disk usage
goinfre-setup                  # Manually run setup
goinfre-install-extensions     # Install VS Code extensions
goinfre-save-extensions        # Save current extensions
```

---

## The Problem

**At Hive/42:**
- Network drive: 10GB limit
- VS Code cache: 1.9GB
- node_modules: 500MB+ per project
- Result: Constantly out of space

**Goinfre:**
- Local disk with 228GB available
- Persists between sessions (not wiped!)
- But NOT backed up (machine-specific)

---

## How It Works

**On Login:**
```
You log in → Shell starts → goinfre-setup runs automatically
→ Symlink created → VS Code ready (no extensions yet)
```

**During Session:**
```
VS Code works normally → Data writes to goinfre → Network drive stays empty
```

**On Logout:**
```
VS Code data stays in goinfre → Safe on THIS machine
→ Different machine? Extension list on network drive → Run goinfre-install-extensions (~2 min)
```

---

## Results

**Before:**
```
████████████████████░ 98% (249MB free)
```

**After:**
```
██████████░░░░░░░░░░ 51% (4.6GB free!)
```

**Freed: 4.4GB** (almost half your drive!)

---

## What This Does

- ✅ **Stores VS Code data in goinfre** (1.9GB freed from network drive)
- ✅ **Creates symlinks** (VS Code doesn't know the difference)
- ✅ **Saves extension list** (survives logout, reinstalls in ~2 min)
- ✅ **Analyzes disk usage** (find space hogs instantly)
- ✅ **Runs on login** (automatic setup every time)

---

## Commands Reference

After installation, these commands are available:

| Command | Description | When to Use |
|---------|-------------|-------------|
| `goinfre-disk-report` | Show what's using space | Anytime you're running low |
| `goinfre-setup` | Run setup manually | Rarely needed (runs automatically) |
| `goinfre-install-extensions` | Install all VS Code extensions | After logout/login (~2-5 min) |
| `goinfre-save-extensions` | Update extension manifest | After installing new extensions |

---

## Installation Details

### Prerequisites
- Hive/42 school environment
- Flatpak VS Code
- Access to goinfre directory
- zsh or bash shell

### What Gets Installed
```
~/.goinfre-dev/                      # On network drive (persistent)
  └── vscode-extensions.txt          # Your 16 extensions

~/github/goinfre_dev/                # On network drive (persistent)
  ├── scripts/                       # All automation
  ├── pm/                            # Planning docs
  └── README.md

~/goinfre/                           # Local disk (temporary)
  └── vscode-data/                   # 1.9GB VS Code data

~/.var/app/
  └── com.visualstudio.code/         # → Symlink to goinfre
```

### Shell Integration
Adds to your `~/.zshrc`:
```bash
# Auto-setup on shell start
~/github/goinfre_dev/scripts/goinfre-setup.sh

# Convenient aliases
alias goinfre-disk-report='...'
alias goinfre-setup='...'
# ... etc
```

---

## Workflow After Logout

1. **Login to any machine**
   - Shell starts → goinfre-setup runs automatically
   - VS Code ready with symlink

2. **Open VS Code**
   - Works immediately
   - No extensions yet

3. **Install extensions** (manual, ~2-5 min)
   ```bash
   goinfre-install-extensions
   ```

4. **Back to normal**
   - All 16 extensions loaded
   - Continue working

---

## Safety & Rollback

### Backup Created
Before first run, full backup at:
```
~/.goinfre-dev-backup/vscode-backup-TIMESTAMP/
```

### If Something Goes Wrong
```bash
# Remove symlink
rm ~/.var/app/com.visualstudio.code

# Restore from backup
mv ~/.goinfre-dev-backup/vscode-backup-* ~/.var/app/com.visualstudio.code
```

---

## Adding New Extensions

Install extensions through VS Code GUI, then:
```bash
goinfre-save-extensions
```

Next time you run `goinfre-install-extensions`, your new extensions will be included!

---

## License

MIT License - Use freely, modify freely, share freely.
