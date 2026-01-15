#!/usr/bin/env zsh
# ============================================
# ZSH Configuration File
# ============================================
# Author: ramxcodes
# Last Updated: 2026-01-15
# Description: Zsh configuration
# ============================================

# ============================================
# ENVIRONMENT SETUP
# ============================================

# XDG Base Directory specification
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

# Path configuration
HOMEBREW_PREFIX="/opt/homebrew"
BUN_INSTALL="$HOME/.bun"
LOCAL_BIN="$HOME/.local/bin"

# Create necessary directories
mkdir -p "$XDG_CONFIG_HOME/zsh"
mkdir -p "$LOCAL_BIN"

# ============================================
# HISTORY CONFIGURATION
# ============================================

HISTSIZE=10000
SAVEHIST=$HISTSIZE
HISTFILE="$XDG_CONFIG_HOME/zsh/.zsh_history"

# History options
setopt APPEND_HISTORY           # Append to history file
setopt SHARE_HISTORY            # Share history across sessions
setopt HIST_IGNORE_SPACE        # Ignore commands starting with space
setopt HIST_IGNORE_ALL_DUPS     # Remove all duplicate entries
setopt HIST_SAVE_NO_DUPS        # Don't save duplicates
setopt HIST_IGNORE_DUPS         # Ignore consecutive duplicates
setopt HIST_FIND_NO_DUPS        # Don't display duplicates when searching
setopt HIST_EXPIRE_DUPS_FIRST   # Expire duplicates first
setopt HIST_VERIFY              # Show command with history expansion before running

# ============================================
# ZINIT PLUGIN MANAGER
# ============================================

ZINIT_HOME="$XDG_DATA_HOME/zinit/zinit.git"

# Install Zinit if not present
install_zinit() {
    echo "Installing Zinit..."
    mkdir -p "$(dirname "$ZINIT_HOME")"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
}

# Check and install Zinit
if [[ ! -d "$ZINIT_HOME" ]]; then
    install_zinit
fi

# Source Zinit
source "$ZINIT_HOME/zinit.zsh"

# ============================================
# ZSH PLUGINS
# ============================================

# Syntax highlighting (load first for better performance)
zinit light zsh-users/zsh-syntax-highlighting

# Completions
zinit light zsh-users/zsh-completions

# Autosuggestions
zinit light zsh-users/zsh-autosuggestions

# FZF tab completion
zinit light Aloxaf/fzf-tab

# History substring search (search history with up/down arrows)
zinit light zsh-users/zsh-history-substring-search

# Auto-notify for long running commands
zinit light MichaelAquilina/zsh-auto-notify

# You Should Use - reminds you to use aliases
zinit light MichaelAquilina/zsh-you-should-use

# Better directory listing colors
zinit light trapd00r/LS_COLORS

# Oh My Zsh plugins (useful snippets)
zinit snippet OMZP::git
zinit snippet OMZP::sudo          # Press ESC twice to add sudo
zinit snippet OMZP::command-not-found
zinit snippet OMZP::extract       # Universal extract command
zinit snippet OMZP::copyfile      # Copy file contents to clipboard
zinit snippet OMZP::copypath      # Copy current path to clipboard

# ============================================
# PLUGIN CONFIGURATION
# ============================================

# History substring search keybindings
bindkey '^[[A' history-substring-search-up     # Up arrow
bindkey '^[[B' history-substring-search-down   # Down arrow

# Auto-notify configuration
export AUTO_NOTIFY_THRESHOLD=10  # Notify for commands taking >10 seconds
export AUTO_NOTIFY_EXPIRE_TIME=3000  # Notification expires after 3 seconds

# You Should Use configuration
export YSU_MESSAGE_POSITION="after"  # Show message after command
export YSU_HARDCORE=0  # Don't block commands, just remind

# ============================================
# COMPLETION SYSTEM
# ============================================

# Load and initialize completion system with caching
autoload -Uz compinit

# Only regenerate compdump once per day
typeset -i updated_at=$(date +'%j' -r ~/.zcompdump 2>/dev/null || stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)
if [ $(date +'%j') != $updated_at ]; then
    compinit -i
else
    compinit -C -i
fi

# Replay cached completions
zinit cdreplay -q

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'  # Case insensitive
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}" # Colored completion
zstyle ':completion:*' menu select                       # Menu selection
zstyle ':completion:*' rehash true                       # Auto rehash commands
zstyle ':completion::complete:*' gain-privileges 1       # Privilege completion

# FZF tab completion styling
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --color=always --icons $realpath 2>/dev/null || ls --color=always $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza --color=always --icons $realpath 2>/dev/null || ls --color=always $realpath'

# Enable approximate completion
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# ============================================
# KEYBINDINGS
# ============================================

# Use emacs key bindings
bindkey -e

# History search
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# Word manipulation
bindkey '\ew' backward-kill-line    # Alt+W: Kill line backwards
bindkey '^H' backward-kill-word     # Ctrl+H: Kill word backwards
bindkey '^[[3~' delete-char         # Delete key

# ============================================
# CUSTOM FUNCTIONS
# ============================================

# Calculate and display days remaining until a target date
remaining_days() {
    local CUSTOM_DATE=$1

    # Validate date format
    if [[ ! $CUSTOM_DATE =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
        echo "Error: Invalid date format. Use YYYY-MM-DD" >&2
        return 1
    fi

    # Calculate days remaining
    local TODAY=$(date +%s)
    local TARGET
    
    # Portable date parsing (macOS/BSD vs GNU)
    if date --version >/dev/null 2>&1; then
        # GNU date
        TARGET=$(date -d "$CUSTOM_DATE" +%s 2>/dev/null)
    else
        # BSD/macOS date
        TARGET=$(date -j -f "%Y-%m-%d" "$CUSTOM_DATE" +%s 2>/dev/null)
    fi

    # Check if date parsing was successful
    if [[ -z "$TARGET" ]]; then
        echo "Error: Invalid date '$CUSTOM_DATE'" >&2
        return 1
    fi

    local SECONDS_REMAINING=$(( TARGET - TODAY ))
    local DAYS_REMAINING=$(( SECONDS_REMAINING / 86400 ))
    
    # Format the target date nicely
    local PRETTY_DATE
    if date --version >/dev/null 2>&1; then
        PRETTY_DATE=$(date -d "$CUSTOM_DATE" "+%A, %B %d, %Y")
    else
        PRETTY_DATE=$(date -j -f "%Y-%m-%d" "$CUSTOM_DATE" "+%A, %B %d, %Y")
    fi
    
    # Don't allow negative days
    if (( DAYS_REMAINING < 0 )); then
        DAYS_REMAINING=0
    fi

    # ANSI color codes
    local ITALIC_CYAN='\e[1;3;96m'
    local ITALIC_YELLOW='\e[1;3;93m'
    local ITALIC_RED='\e[1;3;91m'
    local RESET='\e[0m'

    # Display motivational quote and countdown
    printf "${ITALIC_CYAN}\t\"Arise, awake, and stop not till the goal is reached.\"\n"
    printf "${ITALIC_YELLOW}\t— Katha Upanishad\n${RESET}\n"
    printf "${ITALIC_RED}\t%d days --> '%s'${RESET}\n" "$DAYS_REMAINING" "$PRETTY_DATE"
}

# Check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Make directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Quick extract function (enhanced by OMZ extract plugin)
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2) tar xjf "$1" ;;
            *.tar.gz) tar xzf "$1" ;;
            *.bz2) bunzip2 "$1" ;;
            *.rar) unrar x "$1" ;;
            *.gz) gunzip "$1" ;;
            *.tar) tar xf "$1" ;;
            *.tbz2) tar xjf "$1" ;;
            *.tgz) tar xzf "$1" ;;
            *.zip) unzip "$1" ;;
            *.Z) uncompress "$1" ;;
            *.7z) 7z x "$1" ;;
            *) echo "'$1' cannot be extracted" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# ============================================
# SHELL INTEGRATIONS
# ============================================

# Starship prompt (check if installed)
if command_exists starship; then
    eval "$(starship init zsh)"
else
    # Fallback to basic prompt
    PROMPT='%F{blue}%~%f %# '
fi

# FZF fuzzy finder (check if installed)
if command_exists fzf; then
    eval "$(fzf --zsh)"
    
    # FZF configuration
    export FZF_DEFAULT_OPTS="
        --height 40%
        --layout=reverse
        --border
        --inline-info
        --color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9
        --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9
        --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6
        --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4"
    
    # Use fd instead of find if available
    if command_exists fd; then
        export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    fi
fi

# Zoxide smart directory jumper (check if installed)
if command_exists zoxide; then
    eval "$(zoxide init --cmd cd zsh)"
fi

# ============================================
# PATH CONFIGURATION
# ============================================

# Function to safely add to PATH
add_to_path() {
    if [[ -d "$1" ]] && [[ ":$PATH:" != *":$1:"* ]]; then
        export PATH="$1:$PATH"
    fi
}

# Add directories to PATH
add_to_path "$LOCAL_BIN"
add_to_path "$BUN_INSTALL/bin"
add_to_path "$HOMEBREW_PREFIX/opt/node@22/bin"
add_to_path "$HOME/.spicetify"

# ============================================
# BUN CONFIGURATION
# ============================================

# Bun completions
if [[ -s "$BUN_INSTALL/_bun" ]]; then
    source "$BUN_INSTALL/_bun"
fi

# ============================================
# NVM CONFIGURATION (Lazy Loading)
# ============================================

# Set NVM directory
export NVM_DIR="$HOME/.nvm"

# Lazy load NVM for better performance
if [[ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ]]; then
    # Create placeholder functions for node, npm, npx, nvm
    lazy_load_nvm() {
        unset -f nvm node npm npx
        source "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"
        [[ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ]] && \
            source "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"
    }

    nvm() {
        lazy_load_nvm
        nvm "$@"
    }

    node() {
        lazy_load_nvm
        node "$@"
    }

    npm() {
        lazy_load_nvm
        npm "$@"
    }

    npx() {
        lazy_load_nvm
        npx "$@"
    }
fi

# ============================================
# ALIASES
# ============================================

# General aliases
alias c='clear'
alias cls='clear'
alias zshrc='${EDITOR:-nano} ~/.zshrc'
alias reload='source ~/.zshrc && echo "✓ ZSH configuration reloaded"'

# Enhanced ls with eza
if command_exists eza; then
    alias ls='eza --icons'
    alias ll='eza -la --icons --git'
    alias lt='eza --tree --icons --level=2'
    alias lta='eza --tree --icons --level=3 --all'
else
    alias ll='ls -lah'
    alias lt='tree -L 2'
fi

# Bun aliases
if command_exists bun; then
    alias bro='bun run dev'
    alias bro-cook='bun run build'
    alias bi='bun install'
    alias ba='bun add'
    alias br='bun remove'
fi

# Git aliases (additional to OMZ plugin)
alias gst='git status'
alias gco='git checkout'
alias gp='git push'
alias gl='git pull'
alias glog='git log --oneline --graph --decorate'

# Directory navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'

# Safety nets
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# System aliases
alias ports='netstat -tulanp'
alias update='brew update && brew upgrade'

# ============================================
# STARTUP DISPLAY
# ============================================

# Only show startup info in interactive terminals
if [[ -t 1 ]]; then
    # Display system info with fastfetch
    if command_exists fastfetch; then
        fastfetch
    fi

    # Display countdown to target date
    # Format: YYYY-MM-DD
    remaining_days "2026-08-13"
    
    echo ""  # Add spacing
fi

# ============================================
# LOCAL CONFIGURATION
# ============================================

# Source local configuration if it exists
# Use this file for machine-specific settings
LOCAL_ZSHRC="$HOME/.zshrc.local"
if [[ -f "$LOCAL_ZSHRC" ]]; then
    source "$LOCAL_ZSHRC"
fi

# ============================================
# END OF CONFIGURATION
# ============================================

# Enable additional shell options
setopt AUTO_CD              # Change directory by typing directory name
setopt AUTO_PUSHD           # Push directories onto stack
setopt PUSHD_IGNORE_DUPS    # Don't push duplicate directories
setopt PUSHD_SILENT         # Don't print directory stack
setopt CORRECT              # Command correction
setopt INTERACTIVE_COMMENTS # Allow comments in interactive shell

# Disable beep
unsetopt BEEP