#!/bin/bash

set -e

# Color definitions
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Welcome message
cat << "EOF"
╔══════════════════════════════════════════╗
║           Dotfiles Installation           ║
║                                          ║
║  Streamlined development environment      ║
║  setup for macOS and Linux                ║
╚══════════════════════════════════════════╝
EOF

echo -e "${BLUE}This script will install and configure your development environment.${NC}"
echo -e "${YELLOW}It will install tools like Neovim, Tmux, ZSH, and configure them with sensible defaults.${NC}"
echo

# Check if make is installed
if ! command -v make &> /dev/null; then
  echo -e "${RED}Error: 'make' is not installed.${NC}"
  
  # Detect OS
  if [[ "$OSTYPE" == "darwin"* ]]; then
    echo -e "${YELLOW}On macOS, you can install it with:${NC}"
    echo "xcode-select --install"
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo -e "${YELLOW}On Linux, you can install it with:${NC}"
    echo "sudo apt-get install make  # Debian/Ubuntu"
    echo "sudo dnf install make      # Fedora"
    echo "sudo yum install make      # CentOS/RHEL"
  fi
  
  exit 1
fi

# Before anything else, make sure the directory structure is organized
organize_directory_structure() {
  if [ -f "scripts/organize-structure.sh" ]; then
    echo -e "${BLUE}Organizing dotfiles directory structure...${NC}"
    chmod +x scripts/organize-structure.sh
    scripts/organize-structure.sh --no-prompt || true
    echo -e "${GREEN}Directory structure organized.${NC}"
  fi
}

# Check if there are existing unmanaged config files
check_existing_configs() {
  local conflicts=0
  
  if [ -f "$HOME/.gitconfig" ] && [ ! -h "$HOME/.gitconfig" ]; then
    echo -e "${YELLOW}Warning: You have an existing .gitconfig file that is not managed by stow.${NC}"
    conflicts=$((conflicts+1))
  fi
  
  if [ -f "$HOME/.zshrc" ] && [ ! -h "$HOME/.zshrc" ]; then
    echo -e "${YELLOW}Warning: You have an existing .zshrc file that is not managed by stow.${NC}"
    conflicts=$((conflicts+1))
  fi
  
  if [ -f "$HOME/.tmux.conf" ] && [ ! -h "$HOME/.tmux.conf" ]; then
    echo -e "${YELLOW}Warning: You have an existing .tmux.conf file that is not managed by stow.${NC}"
    conflicts=$((conflicts+1))
  fi
  
  if [ $conflicts -gt 0 ]; then
    echo -e "${YELLOW}There are $conflicts potential conflicts with existing files.${NC}"
    echo -e "${YELLOW}Running 'make backup' will back up these files before proceeding.${NC}"
    echo
    
    read -p "Do you want to continue? (y/n): " choice
    
    if [[ ! "$choice" =~ ^[Yy]$ ]]; then
      echo -e "${RED}Installation aborted.${NC}"
      exit 1
    fi
  fi
}

# Functions
show_menu() {
  echo -e "${BLUE}Installation Options:${NC}"
  echo -e "  ${GREEN}1${NC}. Install Everything (Recommended)"
  echo -e "  ${GREEN}2${NC}. Select Components to Install"
  echo -e "  ${GREEN}3${NC}. Install in Headless Mode"
  echo -e "  ${GREEN}q${NC}. Quit"
  echo
  read -p "Enter your choice: " choice
  
  case $choice in
    1) install_all ;;
    2) custom_install ;;
    3) headless_install ;;
    q|Q) exit 0 ;;
    *) echo -e "${RED}Invalid choice. Please try again.${NC}"; show_menu ;;
  esac
}

install_all() {
  echo -e "${BLUE}Installing everything...${NC}"
  make all
}

custom_install() {
  echo -e "${BLUE}Select components to install:${NC}"
  
  read -p "Install ZSH? (y/n): " install_zsh
  read -p "Install Neovim? (y/n): " install_nvim
  read -p "Install Tmux? (y/n): " install_tmux
  read -p "Install Git configs? (y/n): " install_git
  read -p "Install VS Code configs? (y/n): " install_vscode
  read -p "Install Cursor configuration? (y/n): " install_cursor
  read -p "Install Zed configurations? (y/n): " install_zed
  read -p "Install Homebrew packages? (y/n): " install_brew
  
  # Always run backup and dependencies
  make backup
  make dependencies
  
  # Install selected components
  [[ "$install_zsh" =~ ^[Yy]$ ]] && make install-zsh
  [[ "$install_nvim" =~ ^[Yy]$ ]] && make install-nvim
  [[ "$install_tmux" =~ ^[Yy]$ ]] && make install-tmux
  [[ "$install_git" =~ ^[Yy]$ ]] && make install-git
  [[ "$install_vscode" =~ ^[Yy]$ ]] && make install-vscode
  [[ "$install_cursor" =~ ^[Yy]$ ]] && make install-cursor
  [[ "$install_zed" =~ ^[Yy]$ ]] && make install-zed
  [[ "$install_brew" =~ ^[Yy]$ ]] && brew/setup-brew.sh install
  
  echo -e "${GREEN}Custom installation completed!${NC}"
}

headless_install() {
  echo -e "${BLUE}Running headless installation...${NC}"
  make headless
}

# Main script
organize_directory_structure
check_existing_configs

if [[ "$1" == "--help" || "$1" == "-h" ]]; then
  echo -e "${BLUE}Dotfiles Installer${NC}"
  echo -e "Usage: $0 [OPTION]"
  echo
  echo -e "Options:"
  echo -e "  --all         Install everything (Recommended)"
  echo -e "  --headless    Install in headless mode"
  echo -e "  --help, -h    Show this help message"
  exit 0
elif [[ "$1" == "--all" ]]; then
  install_all
elif [[ "$1" == "--headless" ]]; then
  headless_install
else
  show_menu
fi

# Final message
echo
echo -e "${GREEN}Installation completed successfully!${NC}"
echo -e "${YELLOW}You may need to restart your terminal or run 'source ~/.zshrc' for all changes to take effect.${NC}"
echo
echo -e "${BLUE}Enjoy your new development environment!${NC}" 