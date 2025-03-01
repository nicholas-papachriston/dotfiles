#!/bin/bash

set -e

# Color definitions
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Detect the operating system
unameOut="$(uname -s)"
case "${unameOut}" in
  Linux*)     MACHINE=Linux;;
  Darwin*)    MACHINE=Mac;;
  CYGWIN*)    MACHINE=Cygwin;;
  MINGW*)     MACHINE=MinGw;;
  *)          MACHINE="UNKNOWN:${unameOut}"
esac

echo -e "${BLUE}Detected system: ${MACHINE}${NC}"

# Install Neovim if not already installed
if ! command -v nvim &> /dev/null; then
  echo -e "${BLUE}Neovim not found, installing...${NC}"
  
  if [[ $MACHINE == "Mac" ]]; then
    if command -v brew &> /dev/null; then
      brew install neovim
    else
      echo -e "${RED}Homebrew not found. Please install Homebrew first.${NC}"
      exit 1
    fi
  elif [[ $MACHINE == "Linux" ]]; then
    if command -v apt-get &> /dev/null; then
      sudo apt-get update
      sudo apt-get install -y neovim
    elif command -v dnf &> /dev/null; then
      sudo dnf install -y neovim
    elif command -v yum &> /dev/null; then
      sudo yum install -y neovim
    else
      echo -e "${RED}Unsupported Linux distribution. Please install Neovim manually.${NC}"
      exit 1
    fi
  fi
  
  echo -e "${GREEN}Neovim installed successfully!${NC}"
else
  echo -e "${GREEN}Neovim is already installed.${NC}"
fi

# Create necessary directories
echo -e "${BLUE}Creating Neovim configuration directories...${NC}"
mkdir -p ~/.config/nvim/lua
mkdir -p ~/.local/share/nvim/site/pack/packer/start
mkdir -p ~/.local/share/nvim/lazy

# Install LazyVim
if [ -f "$(dirname "$0")/install-lazynvim.lua" ]; then
  echo -e "${BLUE}Installing LazyVim plugins...${NC}"
  LAZY_SCRIPT="$(dirname "$0")/install-lazynvim.lua"
  
  # Temporarily copy the script to the right location
  TMP_INIT_LUA="/tmp/init.lua"
  echo "require('install-lazynvim')" > "$TMP_INIT_LUA"
  
  # Run Neovim with the temporary init.lua
  NVIM_APPNAME='' nvim --headless --noplugin -u "$TMP_INIT_LUA" -c "luafile $LAZY_SCRIPT" -c 'qall'
  
  # Clean up
  rm "$TMP_INIT_LUA"
  
  echo -e "${GREEN}LazyVim plugins installed successfully!${NC}"
else
  echo -e "${RED}LazyVim installation script not found at $(dirname "$0")/install-lazynvim.lua${NC}"
  exit 1
fi

echo -e "${GREEN}Neovim setup completed successfully!${NC}" 