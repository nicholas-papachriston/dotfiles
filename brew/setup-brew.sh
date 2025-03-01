#!/bin/bash

set -e

# Color definitions
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PARENT_DIR="$(dirname "$SCRIPT_DIR")"
BREWFILE="$PARENT_DIR/Brewfile"

# Function to check if Homebrew is installed
check_brew() {
    if ! command -v brew &> /dev/null; then
        echo -e "${RED}Homebrew is not installed.${NC}"
        return 1
    fi
    return 0
}

# Function to install Homebrew
install_homebrew() {
    if [[ "$(uname)" == "Darwin" ]]; then
        echo -e "${BLUE}Installing Homebrew for macOS...${NC}"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    elif [[ "$(uname)" == "Linux" ]]; then
        echo -e "${BLUE}Installing Homebrew for Linux...${NC}"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add Homebrew to PATH on Linux
        test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
        test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        
        if command -v brew &> /dev/null; then
            echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.profile
            eval "$($(brew --prefix)/bin/brew shellenv)"
        fi
    else
        echo -e "${RED}Unsupported operating system.${NC}"
        exit 1
    fi
    
    # Verify installation
    if ! command -v brew &> /dev/null; then
        echo -e "${RED}Failed to install Homebrew.${NC}"
        exit 1
    else
        echo -e "${GREEN}Homebrew installed successfully!${NC}"
    fi
}

# Function to install essential development packages
install_essentials() {
    echo -e "${BLUE}Installing essential development packages...${NC}"
    brew install stow neovim tmux ripgrep fd fzf bat git
    echo -e "${GREEN}Essential packages installed!${NC}"
}

# Function to install packages from Brewfile
install_from_brewfile() {
    if [ -f "$BREWFILE" ]; then
        echo -e "${BLUE}Installing packages from Brewfile...${NC}"
        brew bundle install --file="$BREWFILE"
        echo -e "${GREEN}Brewfile packages installed!${NC}"
    else
        echo -e "${YELLOW}Brewfile not found at $BREWFILE. Installing essential packages instead.${NC}"
        install_essentials
    fi
}

# Function to export current Homebrew packages to Brewfile
export_to_brewfile() {
    echo -e "${BLUE}Exporting current Homebrew configuration to Brewfile...${NC}"
    brew bundle dump --force --file="$BREWFILE"
    echo -e "${GREEN}Brewfile created at $BREWFILE${NC}"
}

# Main script logic
if [ "$1" == "export" ]; then
    if check_brew; then
        export_to_brewfile
    else
        echo -e "${RED}Cannot export: Homebrew is not installed.${NC}"
        exit 1
    fi
elif [ "$1" == "install" ]; then
    if ! check_brew; then
        echo -e "${YELLOW}Homebrew not found. Installing now...${NC}"
        install_homebrew
    fi
    
    install_from_brewfile
elif [ "$1" == "essentials" ]; then
    if ! check_brew; then
        echo -e "${YELLOW}Homebrew not found. Installing now...${NC}"
        install_homebrew
    fi
    
    install_essentials
else
    echo -e "${BLUE}Homebrew Setup Script${NC}"
    echo -e "Usage: $0 [OPTION]"
    echo
    echo -e "Options:"
    echo -e "  ${YELLOW}export${NC}     - Export current Homebrew packages to Brewfile"
    echo -e "  ${YELLOW}install${NC}    - Install Homebrew and packages from Brewfile"
    echo -e "  ${YELLOW}essentials${NC} - Install Homebrew and essential development packages only"
    echo
    echo -e "Example:"
    echo -e "  $0 export     # Export packages from current machine"
    echo -e "  $0 install    # Install packages on a new machine"
fi 