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

# Install tmux if not already installed
if ! command -v tmux &> /dev/null; then
  echo -e "${BLUE}tmux not found, installing...${NC}"
  
  if [[ $MACHINE == "Mac" ]]; then
    if command -v brew &> /dev/null; then
      brew install tmux
    else
      echo -e "${RED}Homebrew not found. Please install Homebrew first.${NC}"
      exit 1
    fi
  elif [[ $MACHINE == "Linux" ]]; then
    if command -v apt-get &> /dev/null; then
      sudo apt-get update
      sudo apt-get install -y tmux
    elif command -v dnf &> /dev/null; then
      sudo dnf install -y tmux
    elif command -v yum &> /dev/null; then
      sudo yum install -y tmux
    else
      echo -e "${RED}Unsupported Linux distribution. Please install tmux manually.${NC}"
      exit 1
    fi
  fi
  
  echo -e "${GREEN}tmux installed successfully!${NC}"
else
  echo -e "${GREEN}tmux is already installed.${NC}"
fi

# Install Tmux Plugin Manager (TPM)
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [ ! -d "$TPM_DIR" ]; then
  echo -e "${BLUE}Installing Tmux Plugin Manager...${NC}"
  mkdir -p "$HOME/.tmux/plugins"
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
  echo -e "${GREEN}Tmux Plugin Manager installed successfully!${NC}"
else
  echo -e "${GREEN}Tmux Plugin Manager is already installed.${NC}"
fi

# Install tmux plugins
echo -e "${BLUE}Installing tmux plugins...${NC}"
if [ -f "$TPM_DIR/bin/install_plugins" ]; then
  "$TPM_DIR/bin/install_plugins" > /dev/null 2>&1
  echo -e "${GREEN}tmux plugins installed successfully!${NC}"
else
  echo -e "${RED}Plugin installer not found. Manual plugin installation required.${NC}"
  echo -e "${BLUE}Please press prefix + I (capital i) once tmux is started to install plugins.${NC}"
fi

echo -e "${GREEN}tmux setup completed successfully!${NC}"
echo -e "${BLUE}Note: You may need to start a new tmux session for changes to take effect.${NC}" 