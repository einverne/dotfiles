# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"

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
  MichaelAquilina/zsh-you-should-use \
  zdharma-continuum/history-search-multi-word \
#   atload"alias zi='zinit'"

# zinit ice wait"2" as"command" from"gh-r" lucid \
#   mv"zoxide*/zoxide -> zoxide" \
#   atclone"./zoxide init zsh > init.zsh" \
#   atpull"%atclone" src"init.zsh" nocompile'!'
# zinit light ajeetdsouza/zoxide

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
zinit ice lucid wait='0' atinit='zpcompinit'
zinit light zdharma-continuum/fast-syntax-highlighting

# 自动建议

zinit ice lucid wait="0" atload='_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions

# 补全
zinit ice lucid wait='0'
zinit light zsh-users/zsh-completions

# 加载 OMZ 框架及部分插件
zinit snippet OMZ::lib/completion.zsh
zinit snippet OMZ::lib/history.zsh
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
case `uname` in
Darwin)
  # zinit bundle kiurchv/asdf.plugin.zsh
  # Herd injected NVM configuration
  export NVM_DIR="/Users/einverne/Library/Application Support/Herd/config/nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

  [[ -f "/Applications/Herd.app/Contents/Resources/config/shell/zshrc.zsh" ]] && builtin source "/Applications/Herd.app/Contents/Resources/config/shell/zshrc.zsh"

  # Herd injected PHP 8.3 configuration.
  export HERD_PHP_83_INI_SCAN_DIR="/Users/einverne/Library/Application Support/Herd/config/php/83/"


  # Herd injected PHP binary.
  export PATH="/Users/einverne/Library/Application Support/Herd/bin/":$PATH


  # Herd injected PHP 7.4 configuration.
  export HERD_PHP_74_INI_SCAN_DIR="/Users/einverne/Library/Application Support/Herd/config/php/74/"
  export PATH="/opt/homebrew/opt/php@7.4/bin:$PATH"
  export PATH="/opt/homebrew/opt/php@7.4/sbin:$PATH"


  # Herd injected PHP 8.1 configuration.
  export HERD_PHP_81_INI_SCAN_DIR="/Users/einverne/Library/Application Support/Herd/config/php/81/"

  # Added by Windsurf
  export PATH="/Users/einverne/.codeium/windsurf/bin:$PATH"
  ;;
FreeBSD)
  ;;
esac

#if type brew &>/dev/null; then
#	echo "brew completion"
#    FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
#    #fpath=$(brew --prefix)/share/zsh-completions:$fpath
#	fpath=($HOME/.asdf/completions $fpath)
#fi

#. $(brew --prefix asdf)/asdf.sh
#. $(brew --prefix asdf)/etc/bash_completion.d/asdf.bash
# Compinit : After zinits, before cdreplay
# https://carlosbecker.com/posts/speeding-up-zsh/
#


if [[ -d "$HOME/.asdf" ]]; then
  export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
  asdf completion zsh > "${ASDF_DATA_DIR:-$HOME/.asdf}/completions/_asdf"
  fpath=(${ASDF_DATA_DIR:-$HOME/.asdf}/completions $fpath)
fi

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH

  autoload -Uz compinit
  compinit
fi
fpath=(${ASDF_DIR}/completions $fpath)
autoload -Uz compinit

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

source $HOME/dotfiles/zsh/common.zsh
source $HOME/dotfiles/zsh/keybindings.zsh
source $HOME/dotfiles/zsh/alias.zsh
source $HOME/dotfiles/zsh/env.zsh
source $HOME/dotfiles/zsh/fzf.zsh
source $HOME/dotfiles/zsh/github-copilot-cli.zsh

case `uname` in
Darwin)
	source $HOME/dotfiles/zsh/osx.zsh
	;;
FreeBSD)
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



# Herd injected NVM configuration
# export NVM_DIR="/Users/einverne/Library/Application Support/Herd/config/nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# [[ -f "/Applications/Herd.app/Contents/Resources/config/shell/zshrc.zsh" ]] && builtin source "/Applications/Herd.app/Contents/Resources/config/shell/zshrc.zsh"

# Herd injected PHP 8.3 configuration.
# export HERD_PHP_83_INI_SCAN_DIR="/Users/einverne/Library/Application Support/Herd/config/php/83/"


# Herd injected PHP binary.
# export PATH="/Users/einverne/Library/Application Support/Herd/bin/":$PATH


# Herd injected PHP 7.4 configuration.
# export HERD_PHP_74_INI_SCAN_DIR="/Users/einverne/Library/Application Support/Herd/config/php/74/"
# export PATH="/opt/homebrew/opt/php@7.4/bin:$PATH"
# export PATH="/opt/homebrew/opt/php@7.4/sbin:$PATH"


# Herd injected PHP 8.1 configuration.
# export HERD_PHP_81_INI_SCAN_DIR="/Users/einverne/Library/Application Support/Herd/config/php/81/"

# pnpm
case `uname` in
Darwin)
	export PNPM_HOME="/Users/einverne/Library/pnpm"
	case ":$PATH:" in
	  *":$PNPM_HOME:"*) ;;
	  *) export PATH="$PNPM_HOME:$PATH" ;;
	esac
	;;
esac
# pnpm end

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"

# Initialize mise if available
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh --shims --quiet)"
fi

# OpenClaw Completion
source "/home/einverne/.openclaw/completions/openclaw.zsh"

# bun completions
[ -s "/home/einverne/.bun/_bun" ] && source "/home/einverne/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Entire CLI shell completion
autoload -Uz compinit && compinit && source <(entire completion zsh)

# Added by Nowledge Mem
export PATH="$HOME/.local/bin:$PATH"

