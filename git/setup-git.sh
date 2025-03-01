#!/bin/bash

set -e

# Color definitions
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Get OS information
if [[ "$OSTYPE" == "darwin"* ]]; then
  OS="macOS"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  OS="Linux"
else
  OS="Unknown"
fi

echo -e "${BLUE}Setting up Git for ${OS}...${NC}"

# Check if Git is installed
if ! command -v git &> /dev/null; then
  echo -e "${RED}Git is not installed. Please install Git first.${NC}"
  exit 1
fi

# Check for existing .gitconfig
if [ -f "$HOME/.gitconfig" ] && [ ! -L "$HOME/.gitconfig" ]; then
  echo -e "${YELLOW}Found existing .gitconfig that is not a symlink.${NC}"
  echo -e "${YELLOW}Backing up to .gitconfig.backup${NC}"
  mv "$HOME/.gitconfig" "$HOME/.gitconfig.backup"
fi

# Create global ignore files directory
GLOBAL_IGNORE_DIR="$HOME/.config/git"
mkdir -p "$GLOBAL_IGNORE_DIR"

# Install global .gitignore
DOTFILES_DIR=$(dirname "$(dirname "$(realpath "$0")")")
if [ -f "$DOTFILES_DIR/git/.gitignore_global" ]; then
  echo -e "${BLUE}Installing global .gitignore...${NC}"
  cp "$DOTFILES_DIR/git/.gitignore_global" "$GLOBAL_IGNORE_DIR/ignore"
  git config --global core.excludesfile "$GLOBAL_IGNORE_DIR/ignore"
  echo -e "${GREEN}Global .gitignore installed.${NC}"
fi

# Install global .cursorignore if it exists
if [ -f "$DOTFILES_DIR/.cursorignore" ]; then
  echo -e "${BLUE}Installing global .cursorignore...${NC}"
  if [ ! -f "$HOME/.cursorignore" ] || [ ! -L "$HOME/.cursorignore" ]; then
    cp "$DOTFILES_DIR/.cursorignore" "$HOME/.cursorignore"
    echo -e "${GREEN}Global .cursorignore installed.${NC}"
  else
    echo -e "${YELLOW}A .cursorignore file already exists. Skipping.${NC}"
  fi
fi

# Set up Git user information if not already set
GIT_USERNAME=$(git config --global user.name)
GIT_EMAIL=$(git config --global user.email)

if [ -z "$GIT_USERNAME" ]; then
  echo -e "${YELLOW}Git username not set. Please enter your name:${NC}"
  read -r GIT_USERNAME
  git config --global user.name "$GIT_USERNAME"
fi

if [ -z "$GIT_EMAIL" ]; then
  echo -e "${YELLOW}Git email not set. Please enter your email:${NC}"
  read -r GIT_EMAIL
  git config --global user.email "$GIT_EMAIL"
fi

# Set some sensible git defaults
echo -e "${BLUE}Setting Git defaults...${NC}"

# Default branch name
git config --global init.defaultBranch main

# Set editor to nvim if available, otherwise vim
if command -v nvim &> /dev/null; then
  git config --global core.editor nvim
else
  git config --global core.editor vim
fi

# Set up git aliases
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
git config --global alias.unstage 'reset HEAD --'
git config --global alias.last 'log -1 HEAD'

echo -e "${GREEN}Git setup completed successfully!${NC}" 