# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a Windows-focused dotfiles repository for Git Bash and Windows Terminal. The repository uses PowerShell scripts to create symbolic links from the `home/` directory to the user's home directory, making configuration management portable and version-controlled.

## Architecture

### Symlink-Based Configuration System

The repository's core architecture revolves around two PowerShell setup scripts that create symbolic links:

1. **Dotfiles Setup** (`setup-symlinks.ps1`): Links files from `home/` to `$HOME`
2. **Windows Terminal Setup** (`windows-terminal/setup-windows-terminal.ps1`): Links Windows Terminal config files to the appropriate LocalState directory

Both scripts:
- Require Administrator privileges
- Support dry-run mode for preview
- Auto-install dependencies via Chocolatey (fd, fzf, FiraCode font, Windows Terminal)
- Remove existing files/links before creating new symbolic links
- Skip `.ps1` and `.md` files during symlinking

### Bash Configuration Loading System

The bash environment loads in this order (see `home/.bash_profile:14-19`):
1. `.bash_profile` - Entry point, detects MSYS2 environment, sources git-prompt.sh
2. All `.sh` files in `.bash.d/` directory are sourced automatically

**Key configuration files:**
- `home/.bash.d/shell.sh` - Core shell behavior (history, completion, keybindings, Windows Terminal integration)
- `home/.bash.d/aliases.sh` - Command shortcuts and git aliases
- `home/.bash.d/fzf.sh` - FZF fuzzy finder integration
- `home/.bash.d/clean-up.sh` - Cleanup utilities

### Windows Terminal Integration

The configuration includes OSC 9;9 escape sequence support (see `home/.bash.d/shell.sh:99-105`) that tells Windows Terminal the current working directory. This enables "Duplicate Tab" (Ctrl+Shift+D) to open in the same directory. The integration is triggered via `PROMPT_COMMAND` after each command.

### MSYS2 Detection and PATH Management

The system detects MSYS2 by checking for absence of `NTUSER.DAT` file (see `home/.bash_profile:5-12`). When running in MSYS2, it automatically adds Windows paths for Chocolatey, Sublime Text, Git, and VS Code to PATH.

## Setup Commands

### Initial Setup

```powershell
# Dotfiles setup (run from repository root with Administrator privileges)
PS> .\setup-symlinks.ps1

# Windows Terminal setup
PS> .\windows-terminal\setup-windows-terminal.ps1
```

Both scripts will:
- Prompt for dry-run option
- Prompt for custom home directory (or use `$HOME`)
- Auto-install missing dependencies via Chocolatey

### MSYS2 Setup

For MSYS2 mingw64 (C++ development), point the dotfiles script to the MSYS2 home directory:
```powershell
# When prompted, enter: C:\msys64\home\<username>
```

Then install required packages in MSYS2:
```bash
pacman -S git fd fzf
```

## Development Workflow

### C++ Compilation (MSYS2/MinGW)

The repository includes a Makefile (`home/Makefile`) for quick C++ compilation using fzf file selection:

```bash
# Compile with file selection via fzf
mk

# Compile most recent .cpp file
mkrecent

# Clean all .exe files
mkc
```

The Makefile uses `g++` with flags `-Wall -g` and is designed to be invoked from any directory via the `~/Makefile` path.

## Git Configuration

The repository includes extensive git configuration (`home/.gitconfig`) with custom aliases. Notable aliases:

- `git lg` - Colorful graph log with ISO dates
- `git hist` - Graph log with relative dates
- `git cls` - Clean merged branches (excluding master/dev)
- `git bclean` - Clean branches merged to specified branch
- `git rebasei <branch>` - Interactive rebase from fork point

Git is configured with:
- VS Code as editor and difftool
- LFS support
- Pull rebase enabled
- Auto setup remote on push
- Windows credential helper

## Key Aliases and Functions

### Navigation Aliases
- `gr` - Change to git repository root
- `os` - Open repository root in Sublime Text
- `cpwd` - Copy current directory to clipboard

### Git Shortcuts
- `gcb` - Checkout branch via fzf selection
- `gbd` - Delete branch via fzf selection
- `dd()` function - Smart git diff helper that uses `gh develop..` for feature branches, `gh -5` for main branches

### Terminal Management
- `ss` - Start new Windows Terminal window
- `ssm` - Start new MSYS2 tab in Windows Terminal (preserves current directory)

### Directory Listing
The repository prefers `eza` over standard `ls` when available (see `home/.bash.d/aliases.sh:82-92`), with various aliases like `ll`, `lt` (tree view), `llm` (sort by modified).

## Copilot/Claude Instructions

From `home/copilot-instructions.md`:
- Avoid validating or ingratiating the user, their perspective, or their questions
- Self-refer in 3rd-person perspective by only the name of the LLM
- Never use "I", "Me", etc. to refer to the LLM's "perspective"
- Avoid any self-personifying language

## File Organization

```
.
├── home/                    # Dotfiles to be symlinked to $HOME
│   ├── .bash.d/            # Modular bash configuration scripts
│   ├── .config/            # Application configs
│   ├── .fzf/               # FZF fuzzy finder config
│   ├── .mintty/            # Mintty terminal themes
│   ├── .bash_profile       # Bash entry point
│   ├── .gitconfig          # Git configuration
│   ├── Makefile            # C++ quick-compile makefile
│   └── copilot-instructions.md
├── windows-terminal/       # Windows Terminal configuration
│   ├── settings.json       # WT settings to be symlinked
│   └── setup-windows-terminal.ps1
├── setup-symlinks.ps1      # Main dotfiles setup script
└── README.md
```

## Important Notes

- All PowerShell scripts require Administrator privileges for creating symbolic links
- The bash configuration assumes Windows-style paths and uses `cygpath` for conversion
- History is stored in `~/.bash_eternal_history` with 500K entry limit
- The system uses `noclobber` to prevent accidental file overwrites with `>` redirection
- Tab completion is case-insensitive with hyphen/underscore equivalence
