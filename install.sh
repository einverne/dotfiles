#!/usr/bin/env bash
# install.sh - Entry point for GitHub Codespaces dotfiles setup
# GitHub Codespaces will auto-detect and run this script when dotfiles are enabled.
#
# Usage:
#   ./install.sh            # Auto-detect environment
#   ./install.sh --codespaces  # Force Codespaces mode

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

is_codespaces() {
  [[ -n "${CODESPACES}" ]] || [[ -n "${GITHUB_CODESPACE_TOKEN}" ]]
}

is_linux() {
  [[ "$(uname)" == "Linux" ]]
}

install_apt_packages() {
  echo "==> Installing apt packages..."
  sudo apt-get update -qq
  sudo apt-get install -y -qq \
    zsh \
    git \
    vim \
    tmux \
    curl \
    wget \
    tree \
    htop \
    zip \
    unzip \
    ripgrep \
    fd-find \
    jq \
    fzf \
    2>/dev/null || true

  # fd-find is available as 'fdfind' on Ubuntu, create symlink
  if command -v fdfind &>/dev/null && ! command -v fd &>/dev/null; then
    mkdir -p "$HOME/.local/bin"
    ln -sf "$(which fdfind)" "$HOME/.local/bin/fd"
  fi
}

setup_zinit() {
  if [[ ! -d "$HOME/.zinit/bin" ]]; then
    echo "==> Installing zinit..."
    mkdir -p "$HOME/.zinit"
    git clone --quiet https://github.com/zdharma-continuum/zinit.git "$HOME/.zinit/bin"
  fi
}

setup_dotfiles() {
  echo "==> Linking dotfiles..."
  cd "$DOTFILES_DIR"
  git submodule update --init --recursive --quiet

  ./install -c config/codespaces.conf.yml
}

setup_tmux_plugins() {
  if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
    echo "==> Installing tmux plugin manager..."
    git clone --quiet https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
  fi
}

set_default_shell() {
  if command -v zsh &>/dev/null; then
    ZSH_PATH="$(which zsh)"
    if [[ "$SHELL" != "$ZSH_PATH" ]]; then
      echo "==> Setting zsh as default shell..."
      if grep -q "$ZSH_PATH" /etc/shells 2>/dev/null; then
        sudo chsh -s "$ZSH_PATH" "$USER" 2>/dev/null || true
      else
        echo "$ZSH_PATH" | sudo tee -a /etc/shells > /dev/null
        sudo chsh -s "$ZSH_PATH" "$USER" 2>/dev/null || true
      fi
    fi
  fi
}

main() {
  echo "==> Starting dotfiles setup..."
  echo "    OS: $(uname -s)"
  echo "    Codespaces: $(is_codespaces && echo 'yes' || echo 'no')"

  if is_linux; then
    install_apt_packages
  fi

  setup_zinit
  setup_dotfiles
  setup_tmux_plugins
  set_default_shell

  echo ""
  echo "==> Dotfiles setup complete!"
  echo "    Restart your shell or run: exec zsh"
}

main "$@"
