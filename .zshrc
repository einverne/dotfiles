# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# you need to git clone git@github.com:zsh-users/antigen.git to $HOME
if [[ -d $HOME/antigen ]]; then
    source $HOME/antigen/antigen.zsh
fi

if [[ -f "$HOME/antigen.zsh" ]]; then
    source $HOME/antigen.zsh
fi

if [[ -f "$HOME/dotfiles/wp-completion.bash" ]]; then
	autoload bashcompinit
	bashcompinit
	source $HOME/dotfiles/wp-completion.bash
fi

export ASDF_DIR=$(brew --prefix asdf)

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle asdf
antigen bundle gem
antigen bundle git
antigen bundle git-extras
antigen bundle git-flow
antigen bundle mvn
antigen bundle tig
antigen bundle heroku
antigen bundle lein
antigen bundle command-not-found
antigen bundle tmux
antigen bundle tmuxinator
antigen bundle docker
antigen bundle docker-compose

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen bundle Tarrasch/zsh-autoenv
antigen bundle rupa/z
antigen bundle supercrabtree/k
antigen bundle zsh-users/zsh-history-substring-search
#antigen bundle tylerreckart/hyperzsh
#antigen bundle extract
antigen bundle z
#antigen bundle mafredri/zsh-async
#antigen bundle sindresorhus/pure
antigen bundle unixorn/autoupdate-antigen.zshplugin

antigen bundle djui/alias-tips

# Python Plugins
antigen bundle pip
antigen bundle python
antigen bundle virtualenv


# OS specific plugins
case `uname` in
Darwin)
	antigen bundle brew
    antigen bundle brew-cask
    antigen bundle osx
	;;
FreeBSD)
	;;
esac

if type brew &>/dev/null; then
	echo "brew completion"
    FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
    #fpath=$(brew --prefix)/share/zsh-completions:$fpath
	fpath=($HOME/.asdf/completions $fpath)


fi

autoload -Uz compinit && compinit
. $(brew --prefix asdf)/asdf.sh
. $(brew --prefix asdf)/etc/bash_completion.d/asdf.bash


# Load the theme.
# antigen theme agnoster
# workaround for https://github.com/zsh-users/antigen/issues/675
THEME=denysdovhan/spaceship-prompt
antigen list | grep $THEME; if [ $? -ne 0 ]; then antigen theme $THEME; fi

# Tell Antigen that you're done.
antigen apply

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
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"


#transfer() { if [ $# -eq 0 ]; then echo -e "No arguments specified. Usage:\necho transfer /tmp/test.md\ncat /tmp/test.md | transfer test.md"; return 1; fi 
#tmpfile=$( mktemp -t transferXXX ); if tty -s; then basefile=$(basename "$1" | sed -e 's/[^a-zA-Z0-9._-]/-/g'); curl --progress-bar --upload-file "$1" "https://transfer.sh/$basefile" >> $tmpfile; else curl --progress-bar --upload-file "-" "https://transfer.sh/$1" >> $tmpfile ; fi; cat $tmpfile; rm -f $tmpfile; } 

source $HOME/dotfiles/zsh/common.zsh
source $HOME/dotfiles/zsh/keybindings.zsh
source $HOME/dotfiles/zsh/alias.zsh
source $HOME/dotfiles/zsh/env.zsh
source $HOME/dotfiles/zsh/fzf.zsh

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

fpath=(~/.zsh/completions $fpath)

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


