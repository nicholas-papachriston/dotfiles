# Neovim Configuration

This directory contains configuration files for Neovim, based on [LazyVim](https://www.lazyvim.org/).

## Installation

1. Make sure Neovim is installed:
   ```bash
   brew install neovim
   ```

2. Install a Nerd Font for proper icon display:
   ```bash
   brew install --cask font-jetbrains-mono-nerd-font
   ```

3. Use stow to symlink the configuration:
   ```bash
   stow nvim
   ```

4. Launch Neovim. LazyVim will automatically install all plugins on first run.

## Features

- Modern IDE-like experience with minimalist design
- Lazy-loaded plugins for fast startup
- LSP (Language Server Protocol) integration for intelligent code completion
- Telescope for fuzzy finding and navigation
- Git integration with fugitive and gitsigns
- Treesitter for syntax highlighting and code folding
- Terminal integration
- Beautiful and functional UI with bufferline, lualine, and trouble

## Key Mappings

The Leader key is set to `Space`.

### General
- `<Space>` - Opens the whichkey menu for shortcuts
- `<Esc>` - Clear search highlighting
- `<C-s>` - Save file
- `<C-q>` - Quit

### Navigation
- `<Space>ff` - Find files
- `<Space>fg` - Live grep
- `<Space>fb` - Browse buffers
- `<Space>fh` - Help tags
- `<Space>fo` - Recent files
- `<Space>fc` - Find word under cursor
- `<Space>n` - Toggle file explorer

### Windows and Buffers
- `<Space>w` - Window commands
- `<Space>-` - Split window horizontally
- `<Space>|` - Split window vertically
- `<Space>c` - Close buffer

### Code
- `gd` - Go to definition
- `gr` - Go to references
- `K` - Show documentation
- `<Space>ca` - Code actions
- `<Space>cr` - Rename symbol
- `<Space>cf` - Format code
- `<Space>cd` - Toggle diagnostics

### Git
- `<Space>gg` - Lazygit
- `<Space>gj` - Next hunk
- `<Space>gk` - Previous hunk
- `<Space>gs` - Stage hunk
- `<Space>gr` - Reset hunk
- `<Space>gb` - Blame line

### Terminal
- `<Space>ft` - Float terminal
- `<Space>fT` - Vertical terminal

## Customization

To customize the configuration:

1. Edit `init.lua` for base settings
2. Add or modify files in the `lua/plugins` directory to customize plugins
3. Add or modify files in the `lua/config` directory for plugin configurations

## Troubleshooting

If you encounter issues:

1. Check health status: `:checkhealth`
2. Update plugins: `:Lazy update`
3. Clean and reinstall plugins: `:Lazy clean` followed by `:Lazy install`

For more detailed information, refer to the [LazyVim documentation](https://www.lazyvim.org/). 