# dotfiles

Largely inspired by Paul's [dotfiles](https://github.com/paul/dotfiles).

This repository contains configuration files (dotfiles) for various tools and applications. By using [GNU Stow](https://www.gnu.org/software/stow/), these configurations can easily be managed and deployed across different systems.

# Stow

GNU Stow is a symlink manager that simplifies the management of dotfiles by creating symbolic links from a central directory (this repository) to their target locations in your home directory. This keeps your configurations organized and portable.

For example, if you "stow" the nvim directory, Stow will link its contents into your home directory (e.g., ~/.config/nvim).

# Initial Setup

Ensure you have GNU Stow installed on your system. You can install it using your package manager:

- macOS: brew install stow
- Ubuntu/Debian: sudo apt install stow

Then clone this repo somewhere. Then unstow a configuration. (Not it will error if any files would be overwritten)

For instance running 

```shell
stow nvim
```

Will create the following symslink

```
./dotfiles/nvim/.config/nvim -> ~/.config/nvim
```

# Moving new configs 

Create a new directory in the dotfile repo and commit, then running stow will symlink them back into the correct dir!.


# NVIM

Unstowing nvim will install [lazyvim](https://www.lazyvim.org/)

Make sure to install latest neovim `brew install neovim` and a font `brew install --cast font-jetbrains-mono-nerd-font`

Installing the `zsh.` will also add a nice theme and some plugins.

When running nvim in a code dir. 

The leader key `space` will bring up a menu with short cuts. For instance 

- `space` then `f` (file) then
  - `e` will bring up an side explorer
  - `f` fuzzy search
  - `t` a terminal
- `:` then `G` is a short cut for git commands eg
  -  `G commit -m "fea: foobar"`
- `z` then `c` will folder code under the cursor
