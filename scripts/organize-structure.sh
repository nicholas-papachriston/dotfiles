#!/bin/bash

set -e

# Color definitions
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Parse command line arguments
NO_PROMPT=false
for arg in "$@"; do
  case $arg in
    --no-prompt)
      NO_PROMPT=true
      shift
      ;;
  esac
done

# Welcome message
echo -e "${BLUE}Organizing dotfiles directory structure...${NC}"

# Get the dotfiles directory
DOTFILES_DIR="$(pwd)"

# Create necessary directories
mkdir -p "$DOTFILES_DIR/zsh"
mkdir -p "$DOTFILES_DIR/nvim"
mkdir -p "$DOTFILES_DIR/tmux"
mkdir -p "$DOTFILES_DIR/git"
mkdir -p "$DOTFILES_DIR/vscode"
mkdir -p "$DOTFILES_DIR/ghostty/.config/ghostty"
mkdir -p "$DOTFILES_DIR/scripts"
mkdir -p "$DOTFILES_DIR/utils"

# Function to move files to their proper locations
move_file() {
  source="$1"
  dest="$2"
  
  if [ -f "$source" ]; then
    echo -e "${BLUE}Moving $source to $dest${NC}"
    mkdir -p "$(dirname "$dest")"
    mv "$source" "$dest"
  fi
}

# Organize ZSH files
if [ -f "$DOTFILES_DIR/.zshrc" ]; then
  move_file "$DOTFILES_DIR/.zshrc" "$DOTFILES_DIR/zsh/.zshrc"
fi

if [ -f "$DOTFILES_DIR/.p10k.zsh" ]; then
  move_file "$DOTFILES_DIR/.p10k.zsh" "$DOTFILES_DIR/zsh/.p10k.zsh"
fi

if [ -f "$DOTFILES_DIR/zsh/install-zsh.sh" ] && [ ! -f "$DOTFILES_DIR/zsh/setup-zsh.sh" ]; then
  move_file "$DOTFILES_DIR/zsh/install-zsh.sh" "$DOTFILES_DIR/zsh/setup-zsh.sh"
fi

# Organize tmux files
if [ -f "$DOTFILES_DIR/tmux.conf" ]; then
  move_file "$DOTFILES_DIR/tmux.conf" "$DOTFILES_DIR/tmux/.tmux.conf"
fi

# Organize Ghostty files
if [ -f "$DOTFILES_DIR/ghostty" ] && [ ! -f "$DOTFILES_DIR/ghostty/.config/ghostty/config" ]; then
  move_file "$DOTFILES_DIR/ghostty" "$DOTFILES_DIR/ghostty/.config/ghostty/config"
fi

# Organize setup scripts
if [ -f "$DOTFILES_DIR/setup.sh" ] && [ ! -f "$DOTFILES_DIR/scripts/legacy-setup.sh" ]; then
  move_file "$DOTFILES_DIR/setup.sh" "$DOTFILES_DIR/scripts/legacy-setup.sh"
fi

if [ -f "$DOTFILES_DIR/setup-codespaces.sh" ] && [ ! -f "$DOTFILES_DIR/scripts/legacy-codespaces.sh" ]; then
  move_file "$DOTFILES_DIR/setup-codespaces.sh" "$DOTFILES_DIR/scripts/legacy-codespaces.sh"
fi

# Check for deprecated files
check_remove_file() {
  file="$1"
  if [ -f "$file" ]; then
    echo -e "${YELLOW}Found potentially unnecessary file: $file${NC}"
    
    if [ "$NO_PROMPT" = true ]; then
      # In no-prompt mode, we'll rename it instead of removing
      mv "$file" "$file.bak"
      echo -e "${GREEN}Renamed $file to $file.bak${NC}"
    else
      read -p "Remove this file? (y/n): " remove_file
      if [[ "$remove_file" =~ ^[Yy]$ ]]; then
        rm "$file"
        echo -e "${GREEN}Removed $file${NC}"
      fi
    fi
  fi
}

# Check for files that should be merged or removed
if [ -f "$DOTFILES_DIR/zsh/submodules.sh" ]; then
  check_remove_file "$DOTFILES_DIR/zsh/submodules.sh"
fi

# If .cursorignore doesn't exist, create it from a template
if [ ! -f "$DOTFILES_DIR/.cursorignore" ]; then
  echo -e "${BLUE}Creating .cursorignore from template...${NC}"
  cat > "$DOTFILES_DIR/.cursorignore" << "EOF"
# Cursor Ignore File 
# Add patterns to ignore in Cursor IDE

# OS files
.DS_Store
Thumbs.db

# Editor files
.vscode/
.idea/

# Build outputs
dist/
build/
out/

# Dependencies
node_modules/
vendor/

# Dotfiles specific
zsh/.oh-my-zsh/
nvim/plugged/
EOF
  echo -e "${GREEN}Created .cursorignore file${NC}"
fi

echo -e "${GREEN}Directory structure organization completed!${NC}"
echo -e "${YELLOW}You may now want to run 'make install' to apply your configurations.${NC}" 