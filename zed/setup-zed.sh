#!/bin/bash

set -e

# Color definitions
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CONFIG_DIR="$HOME/.config/zed"

echo -e "${BLUE}Setting up Zed configuration...${NC}"

# Create config directory if it doesn't exist
mkdir -p "$CONFIG_DIR"

# Copy configuration files
echo -e "${BLUE}Copying Zed configuration files...${NC}"
cp -r "$SCRIPT_DIR/.config/zed/"* "$CONFIG_DIR/"

# Create language-specific configuration directories if they don't exist
mkdir -p "$CONFIG_DIR/keymap"
mkdir -p "$CONFIG_DIR/snippets"
mkdir -p "$CONFIG_DIR/themes"

echo -e "${GREEN}Zed configuration has been set up successfully!${NC}"
echo -e "${YELLOW}Note: You may need to restart Zed for changes to take effect.${NC}" 