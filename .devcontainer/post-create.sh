#!/usr/bin/env bash
# post-create.sh - Runs after the Codespaces container is created
# This sets up your personal dotfiles environment

set -e

DOTFILES_DIR="$HOME/dotfiles"

echo "==> Setting up dotfiles in Codespaces..."

# Clone dotfiles if not already present (when not using GitHub dotfiles feature)
if [[ ! -d "$DOTFILES_DIR" ]]; then
  git clone --quiet https://github.com/einverne/dotfiles.git "$DOTFILES_DIR"
fi

# Run the dotfiles installer
if [[ -f "$DOTFILES_DIR/install.sh" ]]; then
  bash "$DOTFILES_DIR/install.sh"
fi

# Install tmux plugins non-interactively
if [[ -d "$HOME/.tmux/plugins/tpm" ]]; then
  "$HOME/.tmux/plugins/tpm/bin/install_plugins" 2>/dev/null || true
fi

echo "==> Post-create setup complete!"
