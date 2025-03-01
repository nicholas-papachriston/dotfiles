SHELL := /bin/bash

# Detect OS
OS := $(shell uname -s)
ifeq ($(OS),Darwin)
	PACKAGE_MANAGER := brew
else ifeq ($(OS),Linux)
	# Detect Linux distribution package manager
	ifneq ($(shell which apt-get 2>/dev/null),)
		PACKAGE_MANAGER := apt
	else ifneq ($(shell which dnf 2>/dev/null),)
		PACKAGE_MANAGER := dnf
	else ifneq ($(shell which yum 2>/dev/null),)
		PACKAGE_MANAGER := yum
	endif
endif

# Directories
DOTFILES_DIR := $(shell pwd)
BACKUP_DIR := $(HOME)/.dotfiles_backup/$(shell date +%Y%m%d_%H%M%S)

# Colors
YELLOW := \033[1;33m
GREEN := \033[1;32m
RED := \033[1;31m
BLUE := \033[1;34m
NC := \033[0m

# Executables
STOW := stow
BREW := brew

.PHONY: all install help dependencies backup clean \
	install-zsh install-nvim install-tmux install-git install-vscode install-cursor install-zed \
	stow-zsh stow-nvim stow-tmux stow-git stow-vscode stow-cursor stow-zed \
	homebrew brew-export brew-install oh-my-zsh headless

help:
	@echo -e "$(BLUE)Dotfiles Makefile$(NC)"
	@echo -e "Available targets:"
	@echo -e "  $(GREEN)make$(NC)              - Show this help message"
	@echo -e "  $(GREEN)make all$(NC)          - Install everything (recommended)"
	@echo -e "  $(GREEN)make install$(NC)      - Install without prompts (headless mode)"
	@echo -e "  $(GREEN)make backup$(NC)       - Backup existing dotfiles"
	@echo -e "  $(GREEN)make clean$(NC)        - Clean stow symlinks"
	@echo -e ""
	@echo -e "Individual components:"
	@echo -e "  $(GREEN)make install-zsh$(NC)  - Install and configure ZSH"
	@echo -e "  $(GREEN)make install-nvim$(NC) - Install and configure Neovim"
	@echo -e "  $(GREEN)make install-tmux$(NC) - Install and configure Tmux"
	@echo -e "  $(GREEN)make install-git$(NC)  - Install and configure Git"
	@echo -e "  $(GREEN)make install-vscode$(NC) - Install VS Code settings"
	@echo -e "  $(GREEN)make install-cursor$(NC) - Install Cursor configuration"
	@echo -e "  $(GREEN)make install-zed$(NC) - Install Zed editor configuration"
	@echo
	@echo -e "Homebrew:"
	@echo -e "  $(GREEN)make brew-export$(NC) - Export current Homebrew packages to Brewfile"
	@echo -e "  $(GREEN)make brew-install$(NC) - Install packages from Brewfile"

all: backup dependencies install

install: stow-zsh stow-nvim stow-tmux stow-git stow-vscode stow-cursor stow-zed
	@echo -e "$(GREEN)All dotfiles have been installed!$(NC)"
	@echo -e "$(YELLOW)NOTE: You may need to restart your terminal or run 'source ~/.zshrc' for changes to take effect.$(NC)"

headless: backup dependencies install
	@echo -e "$(GREEN)Headless installation completed!$(NC)"

dependencies: homebrew
	@echo -e "$(BLUE)Installing dependencies...$(NC)"
ifeq ($(PACKAGE_MANAGER),brew)
	@if [ -f "$(DOTFILES_DIR)/Brewfile" ]; then \
		echo -e "$(BLUE)Installing from Brewfile...$(NC)"; \
		brew bundle install --file="$(DOTFILES_DIR)/Brewfile"; \
	else \
		echo -e "$(BLUE)Installing essential packages...$(NC)"; \
		$(BREW) install stow neovim tmux ripgrep fd fzf bat git; \
	fi
else ifeq ($(PACKAGE_MANAGER),apt)
	sudo apt-get update
	sudo apt-get install -y stow neovim tmux ripgrep fd-find fzf bat git
else ifeq ($(PACKAGE_MANAGER),dnf)
	sudo dnf install -y stow neovim tmux ripgrep fd-find fzf bat git
else ifeq ($(PACKAGE_MANAGER),yum)
	sudo yum install -y stow neovim tmux ripgrep fd fzf bat git
else
	@echo -e "$(RED)Unsupported package manager. Please install dependencies manually.$(NC)"
	@exit 1
endif
	@echo -e "$(GREEN)Dependencies installed successfully!$(NC)"

backup:
	@echo -e "$(BLUE)Backing up existing dotfiles...$(NC)"
	@mkdir -p $(BACKUP_DIR)
	@for dir in zsh nvim tmux git vscode; do \
		for file in $$(find $$dir -type f | sed 's|^[^/]*/||'); do \
			if [ -f $(HOME)/$$file ] && [ ! -h $(HOME)/$$file ]; then \
				mkdir -p $(BACKUP_DIR)/$$(dirname $$file); \
				cp -a $(HOME)/$$file $(BACKUP_DIR)/$$file; \
				echo "Backed up: $$file"; \
			fi; \
		done; \
	done
	@if [ -f $(HOME)/.cursorignore ] && [ ! -h $(HOME)/.cursorignore ]; then \
		cp -a $(HOME)/.cursorignore $(BACKUP_DIR)/.cursorignore; \
		echo "Backed up: .cursorignore"; \
	fi
	@echo -e "$(GREEN)Backup completed to $(BACKUP_DIR)$(NC)"

clean:
	@echo -e "$(BLUE)Cleaning symlinks...$(NC)"
	@for dir in zsh nvim tmux git vscode; do \
		$(STOW) -D $$dir 2>/dev/null || true; \
	done
	@rm -f $(HOME)/.cursorignore 2>/dev/null || true
	@echo -e "$(GREEN)Clean completed!$(NC)"

# Homebrew installation
homebrew:
ifeq ($(OS),Darwin)
	@if ! command -v brew >/dev/null; then \
		echo -e "$(BLUE)Installing Homebrew...$(NC)"; \
		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
		echo -e "$(GREEN)Homebrew installed!$(NC)"; \
	else \
		echo -e "$(GREEN)Homebrew already installed!$(NC)"; \
	fi
else ifeq ($(OS),Linux)
	@if ! command -v brew >/dev/null; then \
		echo -e "$(BLUE)Installing Homebrew on Linux...$(NC)"; \
		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
		test -d ~/.linuxbrew && eval "$$(~/.linuxbrew/bin/brew shellenv)"; \
		test -d /home/linuxbrew/.linuxbrew && eval "$$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"; \
		echo "eval \"\$$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.profile; \
		eval "$$($(brew --prefix)/bin/brew shellenv)"; \
		echo -e "$(GREEN)Homebrew installed!$(NC)"; \
	else \
		echo -e "$(GREEN)Homebrew already installed!$(NC)"; \
	fi
endif

# Oh-My-ZSH installation
oh-my-zsh:
	@if [ ! -d "$(HOME)/.oh-my-zsh" ]; then \
		echo -e "$(BLUE)Installing Oh-My-ZSH...$(NC)"; \
		sh -c "$$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended; \
		echo -e "$(GREEN)Oh-My-ZSH installed!$(NC)"; \
	else \
		echo -e "$(GREEN)Oh-My-ZSH already installed!$(NC)"; \
	fi

# ZSH plugins and theme
zsh-plugins: oh-my-zsh
	@echo -e "$(BLUE)Installing ZSH plugins...$(NC)"
	@if [ ! -d "$(HOME)/.oh-my-zsh/custom/themes/powerlevel10k" ]; then \
		git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$(HOME)/.oh-my-zsh/custom/themes/powerlevel10k"; \
	fi
	@if [ ! -d "$(HOME)/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then \
		git clone https://github.com/zsh-users/zsh-autosuggestions "$(HOME)/.oh-my-zsh/custom/plugins/zsh-autosuggestions"; \
	fi
	@if [ ! -d "$(HOME)/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then \
		git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$(HOME)/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"; \
		chmod 700 "$(HOME)/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"; \
	fi
	@echo -e "$(GREEN)ZSH plugins installed!$(NC)"

# Cursor configuration
stow-cursor:
	@echo -e "$(BLUE)Setting up Cursor configuration...${NC}"
	@if [ -f "$(DOTFILES_DIR)/.cursorignore" ]; then \
		cp "$(DOTFILES_DIR)/.cursorignore" "$(HOME)/.cursorignore"; \
		echo -e "$(GREEN)Cursor configuration installed!$(NC)"; \
	else \
		echo -e "$(RED)Cursor configuration not found.$(NC)"; \
	fi

# Zed configuration
stow-zed:
	@echo -e "$(BLUE)Setting up Zed configuration...${NC}"
	@if [ -d "$(DOTFILES_DIR)/zed/.config" ]; then \
		$(STOW) --no-folding -v -R zed; \
		echo -e "$(GREEN)Zed configuration stowed!$(NC)"; \
	else \
		echo -e "$(RED)Zed configuration not found.$(NC)"; \
	fi

# Stowing configuration files
stow-zsh: zsh-plugins
	@echo -e "$(BLUE)Stowing ZSH configuration...$(NC)"
	$(STOW) --no-folding -v -R zsh
	@echo -e "$(GREEN)ZSH configuration stowed!$(NC)"

stow-nvim:
	@echo -e "$(BLUE)Stowing Neovim configuration...$(NC)"
	$(STOW) --no-folding -v -R nvim
	@echo -e "$(GREEN)Neovim configuration stowed!$(NC)"

stow-tmux:
	@echo -e "$(BLUE)Stowing Tmux configuration...$(NC)"
	$(STOW) --no-folding -v -R tmux
	@echo -e "$(GREEN)Tmux configuration stowed!$(NC)"
	@if [ ! -d "$(HOME)/.tmux/plugins/tpm" ]; then \
		echo -e "$(BLUE)Installing Tmux Plugin Manager...$(NC)"; \
		mkdir -p "$(HOME)/.tmux/plugins"; \
		git clone https://github.com/tmux-plugins/tpm "$(HOME)/.tmux/plugins/tpm"; \
		echo -e "$(GREEN)Tmux Plugin Manager installed!$(NC)"; \
	fi

stow-git:
	@echo -e "$(BLUE)Stowing Git configuration...$(NC)"
	@if [ -f "$(HOME)/.gitconfig" ] && [ ! -h "$(HOME)/.gitconfig" ]; then \
		echo -e "$(YELLOW)Backing up existing .gitconfig...$(NC)"; \
		mv "$(HOME)/.gitconfig" "$(HOME)/.gitconfig.backup"; \
	fi
	chmod +x "$(DOTFILES_DIR)/git/setup-git.sh"
	$(STOW) --no-folding -v -R git
	@echo -e "$(GREEN)Git configuration stowed!$(NC)"

stow-vscode:
	@echo -e "$(BLUE)Stowing VSCode configuration...$(NC)"
	$(STOW) --no-folding -v -R vscode
	@echo -e "$(GREEN)VSCode configuration stowed!$(NC)"

# Full installation of components
install-zsh: stow-zsh
	@echo -e "$(BLUE)Setting ZSH as default shell...$(NC)"
	@if [ "$$SHELL" != "$$(which zsh)" ]; then \
		if [ -z "$$CODESPACES" ]; then \
			chsh -s "$$(which zsh)" "$$(whoami)"; \
		else \
			sudo chsh "$$(id -un)" --shell "$$(which zsh)"; \
		fi; \
		echo -e "$(GREEN)ZSH set as default shell!$(NC)"; \
	else \
		echo -e "$(GREEN)ZSH is already the default shell.$(NC)"; \
	fi
	@if [ -f "$(DOTFILES_DIR)/zsh/setup-zsh.sh" ]; then \
		chmod +x "$(DOTFILES_DIR)/zsh/setup-zsh.sh"; \
	fi

install-nvim: stow-nvim
	@echo -e "$(BLUE)Setting up Neovim...$(NC)"
	@if [ -f "$(DOTFILES_DIR)/nvim/setup-nvim.sh" ]; then \
		chmod +x "$(DOTFILES_DIR)/nvim/setup-nvim.sh"; \
	fi
	@if [ -f "$(HOME)/bin/nvim" ]; then \
		"$(HOME)/bin/nvim" --headless -c 'luafile $(DOTFILES_DIR)/nvim/install-lazynvim.lua' -c 'qall'; \
	elif command -v nvim >/dev/null; then \
		nvim --headless -c 'luafile $(DOTFILES_DIR)/nvim/install-lazynvim.lua' -c 'qall'; \
	fi
	@echo -e "$(GREEN)Neovim setup complete!$(NC)"

install-tmux: stow-tmux
	@echo -e "$(BLUE)Installing Tmux plugins...$(NC)"
	@if [ -f "$(DOTFILES_DIR)/tmux/setup-tmux.sh" ]; then \
		chmod +x "$(DOTFILES_DIR)/tmux/setup-tmux.sh"; \
	fi
	@"$(HOME)/.tmux/plugins/tpm/bin/install_plugins" >/dev/null 2>&1 || true
	@echo -e "$(GREEN)Tmux setup complete!$(NC)"

install-git: stow-git
	@echo -e "$(BLUE)Setting up Git configuration...$(NC)"
	@if [ -f "$(DOTFILES_DIR)/git/setup-git.sh" ]; then \
		"$(DOTFILES_DIR)/git/setup-git.sh"; \
	fi
	@echo -e "$(GREEN)Git configuration complete!$(NC)"

install-vscode: stow-vscode
	@echo -e "$(GREEN)VSCode configuration complete!$(NC)"

install-cursor: stow-cursor
	@echo -e "$(GREEN)Cursor configuration complete!$(NC)"

install-zed: stow-zed
	@echo -e "$(BLUE)Setting up Zed editor...$(NC)"
	@if [ -f "$(DOTFILES_DIR)/zed/setup-zed.sh" ]; then \
		chmod +x "$(DOTFILES_DIR)/zed/setup-zed.sh"; \
		"$(DOTFILES_DIR)/zed/setup-zed.sh"; \
	fi
	@echo -e "$(GREEN)Zed configuration complete!$(NC)"

# Homebrew setup and export
brew-export:
	@echo -e "$(BLUE)Exporting Homebrew configuration...$(NC)"
	@brew bundle dump --force --file=$(DOTFILES_DIR)/Brewfile
	@echo -e "$(GREEN)Homebrew configuration exported!$(NC)"

brew-install:
	@echo -e "$(BLUE)Installing Homebrew packages...$(NC)"
	@brew bundle install --file=$(DOTFILES_DIR)/Brewfile
	@echo -e "$(GREEN)Homebrew packages installed!$(NC)" 