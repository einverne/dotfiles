# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

typeset -U path PATH fpath FPATH

# Drop stale asdf and legacy Flutter entries.
typeset -a _dotfiles_clean_path
_dotfiles_clean_path=()
for _dotfiles_path_entry in "${path[@]}"; do
  if [[ "$_dotfiles_path_entry" == "$HOME/.asdf"* ]]; then
    continue
  elif [[ "$_dotfiles_path_entry" == "$HOME/flutter/flutter_sdk/bin" ]]; then
    continue
  fi
  _dotfiles_clean_path+=("$_dotfiles_path_entry")
done
path=("${_dotfiles_clean_path[@]}")
unset _dotfiles_clean_path _dotfiles_path_entry
unset ASDF_DIR ASDF_DATA_DIR

# Homebrew's completions have to be on fpath before compinit runs. `brew shellenv`
# in .zprofile exports HOMEBREW_PREFIX; probe the standard prefixes only when it
# is missing, so this never has to fork `brew --prefix`.
if [[ -z $HOMEBREW_PREFIX ]]; then
  for _dotfiles_brew_prefix in /opt/homebrew /usr/local /home/linuxbrew/.linuxbrew; do
    if [[ -x $_dotfiles_brew_prefix/bin/brew ]]; then
      HOMEBREW_PREFIX=$_dotfiles_brew_prefix
      break
    fi
  done
  unset _dotfiles_brew_prefix
fi
if [[ -n $HOMEBREW_PREFIX && -d $HOMEBREW_PREFIX/share/zsh/site-functions ]]; then
  fpath=($HOMEBREW_PREFIX/share/zsh/site-functions $fpath)
fi

if [[ ! -f ~/.zinit/bin/zinit.zsh ]]; then
	mkdir ~/.zinit
	git clone https://github.com/zdharma-continuum/zinit.git ~/.zinit/bin
fi

# load zinit
source ~/.zinit/bin/zinit.zsh

# 快速目录跳转
zinit ice lucid wait='1'
# Turbo mode with "wait"
zinit light-mode lucid wait for \
  is-snippet OMZ::lib/history.zsh \
  MichaelAquilina/zsh-you-should-use
#   atload"alias zi='zinit'"

# binary release, unpack provide fzf
zinit ice from"gh-r" as"program"
zinit light junegunn/fzf
zinit light Aloxaf/fzf-tab

# zinit ice from"gh-r" as"program" mv"docker* -> docker-compose" bpick"*linux*"
# zinit load docker/compose
zinit ice as"program" from"gh-r" mv"docker-c* -> docker-compose"
zinit light "docker/compose"

zinit load agkozak/zsh-z
# Ref: zdharma/fast-syntax-highlighting
# Note: Use wait 1 second works for kubectl
#zinit wait lucid for \
#  atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
#    zdharma-continuum/fast-syntax-highlighting \
##  atload"zpcdreplay" wait"1" \
#    #OMZP::kubectl \
#  blockf \
#    zsh-users/zsh-completions \
#  atload"!_zsh_autosuggest_start" \
#    zsh-users/zsh-autosuggestions \
#  as"completion" is-snippet \
#    https://github.com/docker/cli/blob/master/contrib/completion/zsh/_docker \
#    https://github.com/docker/compose/blob/master/contrib/completion/zsh/_docker-compose


# 语法高亮
# This ice runs the one and only compinit of the startup, so everything that
# contributes to fpath has to be in place above. Rebuild the completion dump at
# most once a day; the rest of the time -C skips the security audit and the
# dump rewrite, which together cost ~250ms.
ZSH_COMPDUMP=${ZDOTDIR:-$HOME}/.zcompdump
ZINIT[ZCOMPDUMP_PATH]=$ZSH_COMPDUMP
() {
  setopt localoptions extendedglob
  [[ -n $ZSH_COMPDUMP(#qN.mh-24) ]] && ZINIT[COMPINIT_OPTS]=-C
}
zinit ice lucid atinit='zpcompinit'
zinit light zdharma-continuum/fast-syntax-highlighting

# 自动建议

zinit ice lucid atload'!_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions

# 补全
zinit ice lucid wait='0'
zinit light zsh-users/zsh-completions

# 加载 OMZ 框架及部分插件
# Skip OMZ completion.zsh here: zsh-completions + one compinit pass are enough,
# and OMZ::lib/completion.zsh resets WORDCHARS.
# OMZ::lib/history.zsh is already pulled in by the turbo block near the top.
zinit snippet OMZ::lib/key-bindings.zsh
zinit snippet OMZ::lib/theme-and-appearance.zsh
zinit snippet OMZ::plugins/colored-man-pages/colored-man-pages.plugin.zsh
zinit snippet OMZ::plugins/sudo/sudo.plugin.zsh
#zinit snippet OMZ::plugins/git-flow/git-flow.plugin.zsh
zinit snippet OMZ::plugins/mvn/mvn.plugin.zsh
zinit snippet OMZ::plugins/tmux/tmux.plugin.zsh
zinit snippet OMZ::plugins/tmuxinator/tmuxinator.plugin.zsh
zinit snippet OMZ::plugins/command-not-found/command-not-found.plugin.zsh
zinit snippet OMZ::plugins/pip/pip.plugin.zsh

zinit ice lucid wait='1' has'git'
zinit snippet OMZ::plugins/git/git.plugin.zsh

# Gitignore plugin – commands gii and gi
zinit ice wait"2" lucid
zinit load voronkovich/gitignore.plugin.zsh

zinit load djui/alias-tips

# zinit light denysdovhan/spaceship-prompt
zinit ice depth=1; zinit light romkatv/powerlevel10k

# zinit ice as"program" from"gh-r" mv"exa* -> exa" pick"exa/exa" lucid atload"alias ls='exa --icons'"
# zinit light ogham/exa

# OS specific plugins
# $OSTYPE is set by zsh itself, so this needs no `uname` fork (~12ms each).
case $OSTYPE in
darwin*)
  # zinit bundle kiurchv/asdf.plugin.zsh

  # Homebrew PHP 7.4 (the formula is no longer installed; kept for when it is).
  if [[ -d /opt/homebrew/opt/php@7.4 ]]; then
    export PATH="/opt/homebrew/opt/php@7.4/bin:$PATH"
    export PATH="/opt/homebrew/opt/php@7.4/sbin:$PATH"
  fi

  # Added by Windsurf
  export PATH="/Users/einverne/.codeium/windsurf/bin:$PATH"
  ;;
freebsd*)
  ;;
esac

# compinit already ran from the fast-syntax-highlighting ice above; a second
# pass only re-audits and rewrites the same dump.
# https://carlosbecker.com/posts/speeding-up-zsh/
#
# Byte-compile the dump so the next startup loads the .zwc instead of
# re-parsing ~40k lines of completion definitions.
if [[ -s $ZSH_COMPDUMP && ( ! -s $ZSH_COMPDUMP.zwc || $ZSH_COMPDUMP -nt $ZSH_COMPDUMP.zwc ) ]]; then
  zcompile -R -- $ZSH_COMPDUMP.zwc $ZSH_COMPDUMP
fi

# Load kubectl and helm completions
zinit ice lucid wait='1' has'kubectl' id-as'kubectl-completion' \
  atload'source <(kubectl completion zsh); compdef k=kubectl' \
  zdharma-continuum/null

zinit ice lucid wait='1' has'helm' id-as'helm_completion' \
  atclone'helm completion zsh > _helm' \
  atpull'%atclone' \
  as'completion' nocompile \
  zdharma-continuum/null

zinit ice lucid wait='1' has'mise' id-as'mise-completion' \
  atload'eval "$(mise completion zsh)"' \
  zdharma-continuum/null

# if [ $(date +'%j') != $(stat -f '%Sm' -t '%j' ~/.zcompdump) ]; then
#   compinit;
# else
#   compinit -C;
# fi
# kitty + complete setup zsh | source /dev/stdin

# Load the theme.
# zinit theme agnoster
# workaround for https://github.com/zsh-users/zinit/issues/675


# Tell zinit that you're done.
# zinit apply

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=6'

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"


# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.


#transfer() { if [ $# -eq 0 ]; then echo -e "No arguments specified. Usage:\necho transfer /tmp/test.md\ncat /tmp/test.md | transfer test.md"; return 1; fi
#tmpfile=$( mktemp -t transferXXX ); if tty -s; then basefile=$(basename "$1" | sed -e 's/[^a-zA-Z0-9._-]/-/g'); curl --progress-bar --upload-file "$1" "https://transfer.sh/$basefile" >> $tmpfile; else curl --progress-bar --upload-file "-" "https://transfer.sh/$1" >> $tmpfile ; fi; cat $tmpfile; rm -f $tmpfile; }

source $HOME/dotfiles/zsh/cache.zsh
source $HOME/dotfiles/zsh/common.zsh
source $HOME/dotfiles/zsh/keybindings.zsh
source $HOME/dotfiles/zsh/alias.zsh
source $HOME/dotfiles/zsh/env.zsh
source $HOME/dotfiles/zsh/fzf.zsh
source $HOME/dotfiles/zsh/github-copilot-cli.zsh

case $OSTYPE in
darwin*)
	source $HOME/dotfiles/zsh/osx.zsh
	;;
freebsd*)
	;;
esac

if [[ -f ~/.zshrc.local ]]; then
    source $HOME/.zshrc.local
fi

ZSH_DISABLE_COMPFIX=true

# fpath=(~/.zsh/completions $fpath)

# space
SPACESHIP_DIR_SHOW="${SPACESHIP_DIR_SHOW=true}"
SPACESHIP_DIR_PREFIX="${SPACESHIP_DIR_PREFIX="in "}"
SPACESHIP_DIR_SUFFIX="${SPACESHIP_DIR_SUFFIX="$SPACESHIP_PROMPT_DEFAULT_SUFFIX"}"
SPACESHIP_DIR_TRUNC="0"
SPACESHIP_DIR_TRUNC_REPO="${SPACESHIP_DIR_TRUNC_REPO=true}"
SPACESHIP_DIR_COLOR="${SPACESHIP_DIR_COLOR="cyan"}"

# alias
# adb related
# usage adb-screencap > screen.png
alias adbcap="adb shell screencap -p"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


# pnpm
case $OSTYPE in
darwin*)
	export PNPM_HOME="/Users/einverne/Library/pnpm"
	case ":$PATH:" in
	  *":$PNPM_HOME:"*) ;;
	  *) export PATH="$PNPM_HOME:$PATH" ;;
	esac
	;;
esac
# pnpm end

# Initialize mise if available
if command -v mise >/dev/null 2>&1; then
  export MISE_DATA_DIR="${MISE_DATA_DIR:-$HOME/.local/share/mise}"
  # Current mise build returns no shell code for `activate --shims`, so add shims explicitly.
  [[ -d "$MISE_DATA_DIR/shims" ]] && path=("$MISE_DATA_DIR/shims" $path)
  eval "$(mise activate zsh --quiet)"
fi

if command -v atuin >/dev/null 2>&1; then
  zsh_cached_eval atuin-init atuin init zsh
fi

# OpenClaw Completion
[[ -f "$HOME/.openclaw/completions/openclaw.zsh" ]] && source "$HOME/.openclaw/completions/openclaw.zsh"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Entire CLI shell completion
if command -v entire >/dev/null 2>&1; then
  zsh_cached_eval entire-completion entire completion zsh
fi

# Added by Nowledge Mem
export PATH="$HOME/.local/bin:$PATH"


# Added by Antigravity CLI installer
export PATH="/Users/einverne/.local/bin:$PATH"



# Added by Antigravity IDE
export PATH="/Users/einverne/.antigravity-ide/antigravity-ide/bin:$PATH"

# >>> open-knowledge cli >>>
# ! Contents within this block are managed by OpenKnowledge. Do not edit.
# ! Delete this whole block to opt out — OpenKnowledge will not re-add it.
[ -f "$HOME/.ok/env.sh" ] && . "$HOME/.ok/env.sh"
# <<< open-knowledge cli <<<
