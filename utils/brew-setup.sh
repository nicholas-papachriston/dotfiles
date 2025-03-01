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
BREW_DIR="$PARENT_DIR/brew"
FORMULAE_FILE="$BREW_DIR/formulae.txt"
CASKS_FILE="$BREW_DIR/casks.txt"
TAPS_FILE="$BREW_DIR/taps.txt"

# Create brew directory if it doesn't exist
mkdir -p "$BREW_DIR"

# Function to check if Homebrew is installed
check_brew() {
    if ! command -v brew &> /dev/null; then
        echo -e "${RED}Homebrew is not installed.${NC}"
        echo -e "${YELLOW}You can install it using:${NC}"
        echo '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
        return 1
    fi
    return 0
}

# Function to export current Homebrew packages
export_packages() {
    echo -e "${BLUE}Exporting current Homebrew configuration...${NC}"
    
    # Export taps
    echo -e "${BLUE}Exporting taps...${NC}"
    brew tap > "$TAPS_FILE"
    
    # Export formulae (CLI tools)
    echo -e "${BLUE}Exporting formulae...${NC}"
    brew leaves > "$FORMULAE_FILE"
    
    # Export casks (GUI applications)
    echo -e "${BLUE}Exporting casks...${NC}"
    brew list --cask > "$CASKS_FILE"
    
    echo -e "${GREEN}Homebrew configuration exported to:${NC}"
    echo -e "  Taps: ${YELLOW}$TAPS_FILE${NC}"
    echo -e "  Formulae: ${YELLOW}$FORMULAE_FILE${NC}"
    echo -e "  Casks: ${YELLOW}$CASKS_FILE${NC}"
}

# Function to install Homebrew packages from exported files
install_packages() {
    echo -e "${BLUE}Installing Homebrew packages from exported configuration...${NC}"
    
    # First, make sure Homebrew is installed
    if ! check_brew; then
        echo -e "${YELLOW}Installing Homebrew...${NC}"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # On macOS, we're done here
        # On Linux, we need to add Homebrew to PATH
        if [[ "$(uname)" == "Linux" ]]; then
            echo -e "${YELLOW}Adding Homebrew to PATH...${NC}"
            test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
            test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
            echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.profile
            eval "$($(brew --prefix)/bin/brew shellenv)"
        fi
    fi
    
    # Install taps
    if [ -f "$TAPS_FILE" ]; then
        echo -e "${BLUE}Installing taps...${NC}"
        while read -r tap; do
            echo -e "Tapping ${YELLOW}$tap${NC}..."
            brew tap "$tap" || true
        done < "$TAPS_FILE"
    else
        echo -e "${YELLOW}No taps file found. Skipping...${NC}"
    fi
    
    # Install formulae
    if [ -f "$FORMULAE_FILE" ]; then
        echo -e "${BLUE}Installing formulae...${NC}"
        while read -r formula; do
            echo -e "Installing ${YELLOW}$formula${NC}..."
            brew install "$formula" || true
        done < "$FORMULAE_FILE"
    else
        echo -e "${YELLOW}No formulae file found. Skipping...${NC}"
    fi
    
    # Install casks
    if [ -f "$CASKS_FILE" ]; then
        echo -e "${BLUE}Installing casks...${NC}"
        while read -r cask; do
            echo -e "Installing ${YELLOW}$cask${NC}..."
            brew install --cask "$cask" || true
        done < "$CASKS_FILE"
    else
        echo -e "${YELLOW}No casks file found. Skipping...${NC}"
    fi
    
    echo -e "${GREEN}Homebrew packages installation complete!${NC}"
}

# Main logic
if [ "$1" == "export" ]; then
    if check_brew; then
        export_packages
    fi
elif [ "$1" == "install" ]; then
    install_packages
else
    echo -e "${BLUE}Homebrew Setup Script${NC}"
    echo -e "Usage: $0 [OPTION]"
    echo
    echo -e "Options:"
    echo -e "  ${YELLOW}export${NC}   - Export current Homebrew packages to files"
    echo -e "  ${YELLOW}install${NC}  - Install Homebrew packages from exported files"
    echo
    echo -e "Example:"
    echo -e "  $0 export   # On your source machine"
    echo -e "  $0 install  # On your new machine"
fi 