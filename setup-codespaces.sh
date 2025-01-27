#!/bin/sh

set -eux

if [ ! -d $HOME/dotfiles ]; then
  mv /workspaces/.codespaces/.persistedshare/dotfiles $HOME/dotfiles
fi

cd $HOME

# Make passwordless sudo work
export SUDO_ASKPASS=/bin/true

# Apt shouldn't ask any questions
export DEBIAN_FRONTEND=noninteractive

# Change shell to zsh
sudo chsh "$(id -un)" --shell "/usr/bin/zsh"

# Install useful packages
sudo -E apt-get update
sudo -E apt-get install -y tree libfuse2 stow

# Install neovim
# Ubuntu is the worst
curl -L -o nvim.appimage https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
sudo install -vD -m 755 nvim.appimage /usr/local/bin/nvim
rm nvim.appimage

cd dotfiles

stow nvim ruby zsh git

# Setup Neovim
# Install lazyvim plugins
$HOME/bin/nvim --headless -c 'luafile install-lazynvim.lua' -c 'qall'
