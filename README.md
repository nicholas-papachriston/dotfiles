# dotfiles

Largely inspired by Nic's [dotfiles](https://github.com/ncrmro/dotfiles) who was inspired by Paul's [dotfiles](https://github.com/paul/dotfiles).

This repository contains configuration files (dotfiles) for various tools and applications to create a consistent and efficient development environment across different systems.

Key components:
- ZSH configuration with Oh-My-ZSH and Powerlevel10k theme
- Neovim setup with LazyVim
- Tmux configuration
- Git settings
- VS Code settings
- Terminal configuration (Ghostty)

## Quick Start

```bash
# Clone the repository
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Run the installation script
chmod +x install.sh
./install.sh
```

The interactive installation script will:
1. Detect your operating system
2. Back up your existing configuration files
3. Install necessary dependencies
4. Configure ZSH, Neovim, Tmux, Git, and more
5. Set up a consistent development environment

## Using the Makefile

This repository is built around a powerful Makefile that automates the installation and configuration process. You can use it directly:

```bash
# Install everything (recommended)
make all

# Install only specific components
make install-zsh
make install-nvim
make install-tmux
make install-git
make install-vscode

# Backup your existing configuration
make backup

# Remove symlinks (clean)
make clean
```

Run `make help` to see all available commands.

## Installation Options

### Full Installation (Recommended)

Install everything with sensible defaults:

```bash
./install.sh --all
```

### Custom Installation

Select which components to install:

```bash
./install.sh
# Then select option 2 in the interactive menu
```

### Headless/Unattended Installation

For automated deployment in CI/CD pipelines or on remote servers:

```bash
./install.sh --headless
```

## Configuration Components

### ZSH

- Uses [Oh-My-ZSH](https://ohmyz.sh/) for plugin management
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k) theme for a powerful prompt
- Plugins: git, zsh-autosuggestions, zsh-syntax-highlighting
- Custom aliases and environment configurations

### Neovim

- Based on [LazyVim](https://www.lazyvim.org/)
- Configured for modern development with LSP support
- Key features:
  - File navigation with telescope
  - Git integration
  - Syntax highlighting and intelligent code completion
  - Terminal integration

### Tmux

- Terminal multiplexer for managing multiple sessions
- Vim-style keybindings
- Session persistence with tmux-resurrect
- Integrated with Neovim for seamless navigation

### Git

- Sensible defaults for Git
- Useful aliases for common Git operations
- Global .gitignore

### Terminal (Ghostty)

- Modern terminal emulator configuration
- Custom theme and font settings
- Performance optimizations

## Directory Structure

```
dotfiles/
├── Makefile                # Main automation tool
├── install.sh              # User-friendly installer
├── git/                    # Git configuration
│   ├── .gitconfig
│   └── .gitignore_global
├── nvim/                   # Neovim configuration
│   ├── setup-nvim.sh
│   └── install-lazynvim.lua
├── tmux/                   # Tmux configuration
│   ├── .tmux.conf
│   └── setup-tmux.sh
├── zsh/                    # ZSH configuration
│   ├── .zshrc
│   ├── .p10k.zsh
│   └── setup-zsh.sh
└── vscode/                 # VS Code settings
    └── settings.json
```

## Customization

You can customize any part of these configurations:

1. Edit the files directly in the repository
2. Run `make install` again to update the symlinks

## GitHub Codespaces Support

This dotfiles repository is compatible with GitHub Codespaces. When you create a new codespace, it will automatically:

1. Install ZSH and set it as the default shell
2. Set up your preferred environment with your dotfiles
3. Configure Neovim with LazyVim plugins

## Credits

Inspired by:
- [Nic's dotfiles](https://github.com/ncrmro/dotfiles)
- [Paul's dotfiles](https://github.com/paul/dotfiles)

## License

MIT License
