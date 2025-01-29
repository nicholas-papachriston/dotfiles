# Add Powerlevel10k theme
git submodule add https://github.com/romkatv/powerlevel10k.git zsh/.oh-my-zsh/custom/themes/powerlevel10k
git pull .oh-my-zsh/custom/themes/powerlevel10k
# Add zsh-autosuggestions plugin
git submodule add https://github.com/zsh-users/zsh-autosuggestions.git zsh/.oh-my-zsh/plugins/zsh-autosuggestions
git pull .oh-my-zsh/plugins/zsh-autosuggestions
# Add zsh-syntax-highlighting plugin
git submodule add https://github.com/zsh-users/zsh-syntax-highlighting.git zsh/.oh-my-zsh/plugins/zsh-syntax-highlighting
git pull .oh-my-zsh/plugins/zsh-autosuggestions
# Initialize and update submodules
git submodule update --init --recursive