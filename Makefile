.PHONY: help

help: ## Print command list
	@perl -nle'print $& if m{^[a-zA-Z_-]+:.*?## .*$$}' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

_prepare:
	@git submodule update --init --recursive

_bootstrap:
	@./install -c config/bootstrap.conf.yml

bootstrap: _prepare dotfiles _bootstrap ## Bootstrap new machine

termux: _prepare dotfiles termux ## Bootstrap new termux

mac:
	@./install -c config/macos.conf.yml --plugin-dir dotbot-brew

termux:
	@./install -c config/termux.conf.yml

dotfiles: ## Update dotfiles
	@./install

linux:
	@./install -c config/apt.conf.yml --plugin-dir dotbot-apt-get

snap:
	@./install -c config/snap.conf.yml --plugin-dir dotbot-snap

macos: ## Run macos script
	@./mac_bootstrap.sh
	@./macos/init_mac.sh

crontab:
	@./install --plugin-dir crontab-dotbot -c config/crontab.conf.yml

brew: ## Install brew & cask packages
	@./install -c config/packages.conf.yml --plugin-dir dotbot-brew

tmux: ## Install non-brew tools eg. tmux package manager
	@./install -c config/tmux.conf.yml

asdf: ## Install asdf-vm
	@./install -c config/asdf-install.conf.yml --plugin-dir dotbot-brew
	@./install -c config/asdf.conf.yml --plugin-dir dotbot-asdf

update: ## Update everything
	@make _prepare
	@./install -c config/update.conf.yml

vim: ## Setup vim
	@./install -c config/vim.conf.yml

all: _prepare dotfiles _bootstrap brew tmux asdf ## Run all tasks at once
