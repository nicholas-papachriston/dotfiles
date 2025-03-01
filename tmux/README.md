# Tmux Configuration

This directory contains configuration files for tmux, a terminal multiplexer that allows you to manage multiple terminal sessions within a single window.

## Installation

1. Make sure tmux is installed on your system:
   ```
   brew install tmux
   ```

2. Install Tmux Plugin Manager (TPM):
   ```
   git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
   ```

3. Use stow to symlink the configuration:
   ```
   stow tmux
   ```

4. Open tmux and install plugins by pressing `prefix + I` (default prefix is `Ctrl-a`).

## Features

- Mouse support
- Vim-like keybindings
- Enhanced copy mode
- Session management with tmux-resurrect
- Catppuccin theme
- FZF integration for window/session navigation
- Split panes and window management
- Status line with useful information

## Cheatsheet

### General Commands
- `Ctrl-a` - Prefix key (instead of default `Ctrl-b`)
- `prefix + r` - Reload tmux configuration
- `prefix + ?` - Show key bindings

### Sessions
- `prefix + S` - Save session (tmux-resurrect)
- `prefix + R` - Restore session (tmux-resurrect)
- `tmux new -s <name>` - Create a new session with a name
- `tmux attach -t <name>` - Attach to a session
- `tmux ls` - List sessions
- `prefix + d` - Detach from session

### Windows
- `prefix + c` - Create a new window
- `prefix + ,` - Rename current window
- `prefix + n` - Next window
- `prefix + p` - Previous window
- `Alt-n` - Next window
- `Alt-p` - Previous window
- `prefix + w` - List windows with FZF
- `Alt-i` - Move window left
- `Alt-o` - Move window right
- `prefix + x` - Kill current window/pane

### Panes
- `prefix + |` - Split pane horizontally
- `prefix + -` - Split pane vertically
- `prefix + h/j/k/l` - Navigate panes (vim style)
- `Alt-h/j/k/l` - Resize panes
- `prefix + z` - Toggle pane zoom

### Copy Mode
- `prefix + [` - Enter copy mode
- `v` - Begin selection
- `C-v` - Rectangle selection
- `y` - Copy selection
- `q` - Exit copy mode

See the `.tmux.conf` file for all available configurations and customizations. 