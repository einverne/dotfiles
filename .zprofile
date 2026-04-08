
if [[ $(uname -m) == 'arm64' ]]; then
  # Set PATH, MANPATH, etc., for Homebrew.
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

export MISE_DATA_DIR="${MISE_DATA_DIR:-$HOME/.local/share/mise}"
typeset -U path PATH

# Drop stale asdf entries and remove legacy Node manager paths before wiring up mise.
typeset -a _dotfiles_clean_path
_dotfiles_clean_path=()
for _dotfiles_path_entry in "${path[@]}"; do
  if [[ "$_dotfiles_path_entry" == "$HOME/.asdf"* ]]; then
    continue
  elif [[ "$_dotfiles_path_entry" == "$HOME/flutter/flutter_sdk/bin" ]]; then
    continue
  elif [[ "$_dotfiles_path_entry" == *"/Library/Application Support/Herd/config/"*/versions/node/*/bin ]]; then
    continue
  fi
  _dotfiles_clean_path+=("$_dotfiles_path_entry")
done
path=("${_dotfiles_clean_path[@]}")
unset _dotfiles_clean_path _dotfiles_path_entry
unset ASDF_DIR ASDF_DATA_DIR

# Expose mise shims to login shells and IDEs that do not load interactive hooks.
if [[ -d "$MISE_DATA_DIR/shims" ]]; then
  path=("$MISE_DATA_DIR/shims" $path)
fi

if command -v mise >/dev/null 2>&1; then
  # Keep login-shell SDK env vars aligned with the mise-managed defaults used by IDEs.
  _dotfiles_flutter_root="$(mise where flutter@3.35.0-stable 2>/dev/null)"
  [[ -n "$_dotfiles_flutter_root" ]] && export FLUTTER_ROOT="$_dotfiles_flutter_root"
  unset _dotfiles_flutter_root

  _dotfiles_java_home="$(mise where java 2>/dev/null)"
  [[ -n "$_dotfiles_java_home" ]] && export JAVA_HOME="$_dotfiles_java_home"
  unset _dotfiles_java_home
fi

# Added by OrbStack: command-line tools and integration
source ~/.orbstack/shell/init.zsh 2>/dev/null || :

# Added by Obsidian
export PATH="$PATH:/Applications/Obsidian.app/Contents/MacOS"
