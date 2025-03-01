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

# Install Oh-My-ZSH if not already installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo -e "${BLUE}Installing Oh-My-ZSH...${NC}"
  
  # Install ZSH first if it's not available
  if ! command -v zsh &> /dev/null; then
    echo -e "${BLUE}ZSH not found, installing...${NC}"
    
    if [[ $MACHINE == "Mac" ]]; then
      if command -v brew &> /dev/null; then
        brew install zsh
      else
        echo -e "${RED}Homebrew not found. Please install Homebrew first.${NC}"
        exit 1
      fi
    elif [[ $MACHINE == "Linux" ]]; then
      if command -v apt-get &> /dev/null; then
        sudo apt-get update
        sudo apt-get install -y zsh
      elif command -v dnf &> /dev/null; then
        sudo dnf install -y zsh
      elif command -v yum &> /dev/null; then
        sudo yum install -y zsh
      else
        echo -e "${RED}Unsupported Linux distribution. Please install ZSH manually.${NC}"
        exit 1
      fi
    fi
    
    echo -e "${GREEN}ZSH installed successfully!${NC}"
  fi
  
  # Install Oh-My-ZSH
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  echo -e "${GREEN}Oh-My-ZSH installed successfully!${NC}"
else
  echo -e "${GREEN}Oh-My-ZSH is already installed.${NC}"
fi

# Set ZSH_CUSTOM
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

# Install Powerlevel10k theme
if [ ! -d "${ZSH_CUSTOM}/themes/powerlevel10k" ]; then
  echo -e "${BLUE}Installing Powerlevel10k theme...${NC}"
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM}/themes/powerlevel10k"
  echo -e "${GREEN}Powerlevel10k theme installed successfully!${NC}"
else
  echo -e "${GREEN}Powerlevel10k theme is already installed.${NC}"
fi

# Install ZSH plugins
if [ ! -d "${ZSH_CUSTOM}/plugins/zsh-autosuggestions" ]; then
  echo -e "${BLUE}Installing zsh-autosuggestions plugin...${NC}"
  git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM}/plugins/zsh-autosuggestions"
  echo -e "${GREEN}zsh-autosuggestions plugin installed successfully!${NC}"
else
  echo -e "${GREEN}zsh-autosuggestions plugin is already installed.${NC}"
fi

if [ ! -d "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting" ]; then
  echo -e "${BLUE}Installing zsh-syntax-highlighting plugin...${NC}"
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting"
  chmod 700 "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting"
  echo -e "${GREEN}zsh-syntax-highlighting plugin installed successfully!${NC}"
else
  echo -e "${GREEN}zsh-syntax-highlighting plugin is already installed.${NC}"
fi

# Set ZSH as default shell if it's not already
if [[ "$SHELL" != *"zsh"* ]]; then
  echo -e "${BLUE}Setting ZSH as default shell...${NC}"
  if [[ -z "${CODESPACES}" ]]; then
    chsh -s "$(which zsh)" "$(whoami)"
  else
    sudo chsh "$(id -un)" --shell "$(which zsh)"
  fi
  echo -e "${GREEN}ZSH set as default shell!${NC}"
else
  echo -e "${GREEN}ZSH is already the default shell.${NC}"
fi

echo -e "${GREEN}ZSH setup completed successfully!${NC}" 