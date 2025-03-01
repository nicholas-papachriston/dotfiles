#!/bin/bash

set -eo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print section headers
print_header() {
  echo -e "\n${BLUE}==== $1 ====${NC}\n"
}

# Function to print success messages
print_success() {
  echo -e "${GREEN}✓ $1${NC}"
}

# Function to print info messages
print_info() {
  echo -e "${YELLOW}➜ $1${NC}"
}

# Function to print error messages
print_error() {
  echo -e "${RED}✗ $1${NC}"
}

# Detect OS and machine type
detect_os() {
  print_header "Detecting System Information"
  
  if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="MacOS"
    print_info "Operating System: MacOS $(sw_vers -productVersion)"
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="Linux"
    if [ -f /etc/os-release ]; then
      DISTRO=$(grep -oP '(?<=^ID=).+' /etc/os-release | tr -d '"')
      VERSION=$(grep -oP '(?<=^VERSION_ID=).+' /etc/os-release | tr -d '"')
      print_info "Operating System: Linux ($DISTRO $VERSION)"
    else
      print_info "Operating System: Linux (distribution unknown)"
    fi
  else
    OS="Unknown"
    print_error "Unknown operating system: $OSTYPE"
    exit 1
  fi
}

# Install Homebrew if not already installed
install_homebrew() {
  print_header "Checking for Homebrew"
  
  if command -v brew &>/dev/null; then
    print_success "Homebrew is already installed."
    brew --version
  else
    print_info "Installing Homebrew..."
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH based on OS
    if [[ "$OS" == "MacOS" ]]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ "$OS" == "Linux" ]]; then
      eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi
    
    print_success "Homebrew installed successfully!"
  fi
}

# Install essential packages
install_essentials() {
  print_header "Installing Essential Packages"
  
  PACKAGES=(
    "stow"           # For managing dotfiles
    "nvim"           # Neovim text editor
    "ripgrep"        # Fast grep alternative
    "fd"             # Fast find alternative
    "fzf"            # Fuzzy finder
    "bat"            # Cat with syntax highlighting
    "tmux"           # Terminal multiplexer
    "jesseduffield/lazygit/lazygit" # Git UI
  )
  
  print_info "Installing packages: ${PACKAGES[*]}"
  brew install "${PACKAGES[@]}"
  print_success "Essential packages installed!"
}

# Install language environments
install_languages() {
  print_header "Setting Up Development Environments"
  
  # Ask user which language environments to install
  read -p "Install Node.js? (y/n): " INSTALL_NODE
  read -p "Install Python? (y/n): " INSTALL_PYTHON
  read -p "Install Go? (y/n): " INSTALL_GO
  read -p "Install Rust? (y/n): " INSTALL_RUST
  
  # Install selected environments
  if [[ "$INSTALL_NODE" =~ ^[Yy]$ ]]; then
    print_info "Installing Node.js via nvm..."
    brew install nvm
    mkdir -p "$HOME/.nvm"
    export NVM_DIR="$HOME/.nvm"
    [ -s "$(brew --prefix)/opt/nvm/nvm.sh" ] && . "$(brew --prefix)/opt/nvm/nvm.sh"
    nvm install --lts
    print_success "Node.js installed!"
  fi
  
  if [[ "$INSTALL_PYTHON" =~ ^[Yy]$ ]]; then
    print_info "Installing Python..."
    brew install python@3.11 pyenv
    print_success "Python installed!"
  fi
  
  if [[ "$INSTALL_GO" =~ ^[Yy]$ ]]; then
    print_info "Installing Go..."
    brew install go
    mkdir -p "$HOME/go/{bin,src,pkg}"
    print_success "Go installed!"
  fi
  
  if [[ "$INSTALL_RUST" =~ ^[Yy]$ ]]; then
    print_info "Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    print_success "Rust installed!"
  fi
}

# Configure ZSH
setup_zsh() {
  print_header "Setting Up ZSH"
  
  # Install ZSH if not already installed
  if ! command -v zsh &>/dev/null; then
    print_info "Installing ZSH..."
    if [[ "$OS" == "MacOS" ]]; then
      brew install zsh
    elif [[ "$OS" == "Linux" ]]; then
      if [[ "$DISTRO" == "ubuntu" ]] || [[ "$DISTRO" == "debian" ]]; then
        sudo apt update && sudo apt install -y zsh
      elif [[ "$DISTRO" == "fedora" ]]; then
        sudo dnf install -y zsh
      else
        print_error "Unsupported Linux distribution for automatic ZSH installation."
        return 1
      fi
    fi
    print_success "ZSH installed!"
  else
    print_success "ZSH is already installed."
  fi
  
  # Set ZSH as default shell if it's not already
  if [[ "$SHELL" != *"zsh"* ]]; then
    print_info "Setting ZSH as default shell..."
    if [[ -z "${CODESPACES}" ]]; then
      chsh -s "$(which zsh)" "$(whoami)"
    else
      sudo chsh "$(id -un)" --shell "$(which zsh)"
    fi
    print_success "ZSH set as default shell!"
  else
    print_success "ZSH is already the default shell."
  fi
  
  # Install Oh My Zsh if not already installed
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    print_info "Installing Oh My ZSH..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    print_success "Oh My ZSH installed!"
  else
    print_success "Oh My ZSH is already installed."
  fi
  
  # Install Powerlevel10k theme
  if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    print_info "Installing Powerlevel10k theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
    print_success "Powerlevel10k theme installed!"
  fi
  
  # Install ZSH plugins
  ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
  
  if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    print_info "Installing zsh-autosuggestions plugin..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
  fi
  
  if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    print_info "Installing zsh-syntax-highlighting plugin..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    chmod 700 "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
  fi
  
  print_success "ZSH setup complete!"
}

# Stow dotfiles
stow_dotfiles() {
  print_header "Stowing Dotfiles"
  
  print_info "Stowing ZSH configuration..."
  stow --no-folding -v zsh
  
  print_info "Stowing Git configuration..."
  stow --no-folding -v git
  
  print_info "Stowing Neovim configuration..."
  stow --no-folding -v nvim
  
  print_info "Stowing tmux configuration..."
  stow --no-folding -v tmux
  
  print_success "Dotfiles successfully stowed!"
}

# Setup for GitHub Codespaces if running in that environment
setup_codespaces() {
  print_header "Setting Up GitHub Codespaces"
  
  # Move dotfiles to home directory if needed
  if [ ! -d "$HOME/dotfiles" ] && [ -d "/workspaces/.codespaces/.persistedshare/dotfiles" ]; then
    print_info "Moving dotfiles to home directory..."
    mv /workspaces/.codespaces/.persistedshare/dotfiles "$HOME/dotfiles"
    print_success "Dotfiles moved!"
  fi
  
  # Make passwordless sudo work
  export SUDO_ASKPASS=/bin/true
  
  stow_dotfiles
  
  # Setup Neovim in Codespaces
  print_info "Setting up Neovim..."
  if [ -f "$HOME/bin/nvim" ]; then
    "$HOME/bin/nvim" --headless -c 'luafile install-lazynvim.lua' -c 'qall'
    print_success "Neovim setup complete!"
  else
    print_error "Neovim binary not found at $HOME/bin/nvim"
  fi
  
  print_success "Codespaces setup complete!"
}

# Main function
main() {
  print_header "Starting Dotfiles Setup"
  
  detect_os
  install_homebrew
  install_essentials
  setup_zsh
  
  # Only run language installation in interactive mode
  if [[ -z "${CODESPACES}" ]]; then
    install_languages
  fi
  
  # Run Codespaces setup if in that environment
  if [ -n "${CODESPACES}" ]; then
    setup_codespaces
  else
    stow_dotfiles
  fi
  
  print_header "Setup Complete!"
  print_success "Your dotfiles have been successfully configured."
  print_info "Please restart your terminal or run 'source ~/.zshrc' to apply changes."
}

# Run the main function
main
