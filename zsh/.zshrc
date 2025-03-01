#!/bin/zsh

# Enable Powerlevel10k instant prompt. Should stay close to the top of .zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Theme configuration
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugin configuration
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

# Load Oh-My-Zsh
source $ZSH/oh-my-zsh.sh

#######################
# Environment Variables
#######################

# Editor configuration
export EDITOR="zed --wait"

# Hugging Face
export HF_HUB_ENABLE_HF_TRANSFER=1

# Tool-specific environments
export GO_PATH=$HOME/go
export BUN_INSTALL="$HOME/.bun"

#######################
# Path Configurations
#######################

# Cache brew prefix to avoid repeated calls
if command -v brew &>/dev/null; then
  BREW_PREFIX=$(brew --prefix)
fi

# Initialize path array with system defaults
typeset -U path  # Ensure unique entries in path array

# Add paths in order of priority (first has highest priority)
path=(
  # Homebrew Python paths
  "${BREW_PREFIX}/opt/python@3.11/libexec/bin"
  "/usr/local/Cellar/python@3.11/3.11.10/bin"
  # Go
  "$GO_PATH/bin"
  # Bun
  "$BUN_INSTALL/bin"
  # Local binaries
  "$HOME/.local/bin"
  # Rust
  "$HOME/.cargo/bin"
  # PostgreSQL
  "$HOME/Applications/Postgres.app/Contents/Versions/latest/bin"
  # Keep existing system paths
  $path
)

#######################
# Tool Configurations
#######################

# Node Version Manager (NVM) configuration
export NVM_DIR="$HOME/.nvm"
if [[ -n "$BREW_PREFIX" ]]; then
  NVM_SCRIPT="$BREW_PREFIX/opt/nvm/nvm.sh"
  NVM_COMPLETION="$BREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"
  
  [[ -s "$NVM_SCRIPT" ]] && source "$NVM_SCRIPT"
  [[ -s "$NVM_COMPLETION" ]] && source "$NVM_COMPLETION"
fi

# Bun completions
[[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"

# Google Cloud SDK
[[ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]] && source "$HOME/google-cloud-sdk/path.zsh.inc"
[[ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]] && source "$HOME/google-cloud-sdk/completion.zsh.inc"

# Load custom aliases if they exist
[[ -f "$HOME/.aliases" ]] && source "$HOME/.aliases"

# Load Powerlevel10k theme configuration
[[ -f "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"
