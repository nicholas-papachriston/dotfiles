# Enable Powerlevel10k instant prompt. Should stay close to the top of $HOME/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Theme configuration
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugin configuration
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# Path configurations
# TODO change to use .go
export GO_PATH=$HOME/go
# TODO change to use uv only
export PYENV_ROOT="$HOME/.pyenv"
export BUN_INSTALL="$HOME/.bun"
PATH="$PATH:\
/usr/local/Cellar/python@3.11/3.11.10/bin:\
$GO_PATH/bin:\
$BUN_INSTALL/bin:\
$PYENV_ROOT/bin:\
$HOME/.local/bin"
PATH="$(brew --prefix)/opt/python@3.11/libexec/bin:$PATH"
# Rust
PATH="$PATH:$HOME/.cargo/bin"
# Postgre
export PATH="$HOME/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH"

# Node Version Manager (NVM) configuration
export NVM_DIR="$HOME/.nvm"
[ -s "$(brew --prefix)/opt/nvm/nvm.sh" ] && . "$(brew --prefix)/opt/nvm/nvm.sh"
[ -s "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm" ] && . "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm"

# Bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# Python environment configuration
# TODO change to use uv only
eval "$(pyenv init -)"

# To customize prompt, run `p10k configure` or edit $HOME/.p10k.zsh.
source "$HOME/.p10k.zsh"
