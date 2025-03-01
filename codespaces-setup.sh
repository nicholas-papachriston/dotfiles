#!/bin/bash

set -e

# Color definitions
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}Setting up dotfiles for GitHub Codespaces...${NC}"

# Ensure we're in a GitHub Codespaces environment
if [ -z "${CODESPACES}" ]; then
  echo -e "${RED}This script is intended to be run in GitHub Codespaces only.${NC}"
  echo -e "${YELLOW}Please use './install.sh' for regular installations.${NC}"
  exit 1
fi

# Move dotfiles repository to home directory if needed
if [ -d "/workspaces/.codespaces/.persistedshare/dotfiles" ] && [ ! -d "$HOME/dotfiles" ]; then
  echo -e "${BLUE}Moving dotfiles to home directory...${NC}"
  mv /workspaces/.codespaces/.persistedshare/dotfiles "$HOME/dotfiles"
  cd "$HOME/dotfiles"
fi

# Make passwordless sudo work
export SUDO_ASKPASS=/bin/true

# Install essential tools
echo -e "${BLUE}Installing essential tools...${NC}"
sudo apt-get update
sudo apt-get install -y make stow zsh

# Set ZSH as default shell
echo -e "${BLUE}Setting ZSH as default shell...${NC}"
sudo chsh "$(id -un)" --shell "$(which zsh)"

# Setup dotfiles using our Makefile
echo -e "${BLUE}Installing dotfiles...${NC}"
make headless

# Setup Neovim with LazyVim
if command -v nvim &> /dev/null; then
  echo -e "${BLUE}Setting up Neovim...${NC}"
  # This part is handled by the Makefile, but we double-check
  if [ -f "$HOME/dotfiles/nvim/install-lazynvim.lua" ]; then
    nvim --headless -c "luafile $HOME/dotfiles/nvim/install-lazynvim.lua" -c 'qall'
  fi
fi

echo -e "${GREEN}Codespaces setup completed successfully!${NC}"
echo -e "${YELLOW}You may need to restart your terminal for changes to take effect.${NC}" 