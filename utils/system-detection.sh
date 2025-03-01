#!/bin/bash

# Utility functions for system detection and common operations

# Color definitions
export GREEN='\033[0;32m'
export BLUE='\033[0;34m'
export YELLOW='\033[0;33m'
export RED='\033[0;31m'
export NC='\033[0m' # No Color

# Detect OS
detect_os() {
  unameOut="$(uname -s)"
  case "${unameOut}" in
    Linux*)     
      echo "Linux"
      ;;
    Darwin*)    
      echo "Mac"
      ;;
    CYGWIN*)    
      echo "Cygwin"
      ;;
    MINGW*)     
      echo "MinGw"
      ;;
    *)          
      echo "Unknown"
      ;;
  esac
}

# Detect Linux distribution
detect_linux_distro() {
  if [ -f /etc/os-release ]; then
    # freedesktop.org and systemd
    . /etc/os-release
    echo "$ID"
  elif type lsb_release >/dev/null 2>&1; then
    # linuxbase.org
    echo "$(lsb_release -si | tr '[:upper:]' '[:lower:]')"
  elif [ -f /etc/lsb-release ]; then
    # For some versions of Debian/Ubuntu without lsb_release command
    . /etc/lsb-release
    echo "$DISTRIB_ID" | tr '[:upper:]' '[:lower:]'
  elif [ -f /etc/debian_version ]; then
    # Older Debian/Ubuntu/etc.
    echo "debian"
  elif [ -f /etc/SuSe-release ]; then
    # Older SuSE/etc.
    echo "suse"
  elif [ -f /etc/redhat-release ]; then
    # Older Red Hat, CentOS, etc.
    echo "redhat"
  else
    # Fall back to uname
    echo "unknown"
  fi
}

# Detect package manager
detect_package_manager() {
  os="$(detect_os)"
  
  if [ "$os" = "Mac" ]; then
    echo "brew"
  elif [ "$os" = "Linux" ]; then
    distro="$(detect_linux_distro)"
    
    if [ "$distro" = "ubuntu" ] || [ "$distro" = "debian" ] || [ "$distro" = "linuxmint" ]; then
      echo "apt"
    elif [ "$distro" = "fedora" ]; then
      echo "dnf"
    elif [ "$distro" = "centos" ] || [ "$distro" = "rhel" ] || [ "$distro" = "redhat" ]; then
      echo "yum"
    elif [ "$distro" = "arch" ] || [ "$distro" = "manjaro" ]; then
      echo "pacman"
    else
      echo "unknown"
    fi
  else
    echo "unknown"
  fi
}

# Install a package using the appropriate package manager
install_package() {
  package_name="$1"
  package_manager="$(detect_package_manager)"
  
  echo -e "${BLUE}Installing $package_name...${NC}"
  
  case "$package_manager" in
    brew)
      brew install "$package_name"
      ;;
    apt)
      sudo apt-get update
      sudo apt-get install -y "$package_name"
      ;;
    dnf)
      sudo dnf install -y "$package_name"
      ;;
    yum)
      sudo yum install -y "$package_name"
      ;;
    pacman)
      sudo pacman -Sy --noconfirm "$package_name"
      ;;
    *)
      echo -e "${RED}Unsupported package manager. Please install $package_name manually.${NC}"
      return 1
      ;;
  esac
  
  if [ $? -eq 0 ]; then
    echo -e "${GREEN}$package_name installed successfully!${NC}"
    return 0
  else
    echo -e "${RED}Failed to install $package_name.${NC}"
    return 1
  fi
}

# Check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Print a message with color
print_message() {
  color="$1"
  message="$2"
  
  echo -e "${color}${message}${NC}"
}

# Create a backup of a file
backup_file() {
  file="$1"
  backup_dir="$2"
  
  if [ -f "$file" ] && [ ! -h "$file" ]; then
    mkdir -p "$(dirname "$backup_dir/$file")"
    cp -a "$file" "$backup_dir/$file"
    echo "Backed up: $file"
    return 0
  fi
  
  return 1
} 