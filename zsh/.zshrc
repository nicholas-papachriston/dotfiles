# Path to your oh-my-zsh configuration.
export ZSH=$HOME/.oh-my-zsh

if [[ `uname` == "Darwin" ]]; then
	OSX=1
fi

ZSH_THEME="robbyrussell"

plugins=(
  gem
  git
  git-extras
  github
  kubectl
  kubectx
  nvm
  rails
  rake
  rbenv
  ssh
)

source $ZSH/oh-my-zsh.sh

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

eval "$(rbenv init - --no-rehash zsh)"
