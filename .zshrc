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

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
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
    antigen bundle gem
    antigen bundle osx
	;;
FreeBSD)
	;;
esac

if [[ $CURRENT_OS == 'OS X' ]]; then
    antigen bundle brew
    antigen bundle brew-cask
    antigen bundle gem
    antigen bundle osx
elif [[ $CURRENT_OS == 'Linux' ]]; then
    # None so far...

    if [[ $DISTRO == 'CentOS' ]]; then
        antigen bundle centos
    fi
elif [[ $CURRENT_OS == 'Cygwin' ]]; then
    antigen bundle cygwin
fi

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

source $HOME/dotfiles/conf/zsh/common.zsh
source $HOME/dotfiles/conf/zsh/keybindings.zsh
source $HOME/dotfiles/conf/zsh/alias.zsh
source $HOME/dotfiles/conf/zsh/env.zsh

if [[ -f ~/.zshrc.local ]]; then
    source $HOME/.zshrc.local
fi

ZSH_DISABLE_COMPFIX=true

autoload -Uz compinit && compinit
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

# fzf config
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git --ignore .idea -l -g ""'
#export FZF_DEFAULT_OPTS="--reverse --inline-info"
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --preview '(highlight -O ansi {} || cat {}) 2> /dev/null | head -500'"

# fe [FUZZY PATTERN] - Open the selected file with the default editor
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
fe() {
  local files
  IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
}

# Modified version where you can press
#   - CTRL-O to open with `open` command,
#   - CTRL-E or Enter key to open with the $EDITOR
fo() {
  local out file key
  IFS=$'\n' out=("$(fzf-tmux --query="$1" --exit-0 --expect=ctrl-o,ctrl-e)")
  key=$(head -1 <<< "$out")
  file=$(head -2 <<< "$out" | tail -1)
  if [ -n "$file" ]; then
    [ "$key" = ctrl-o ] && open "$file" || ${EDITOR:-vim} "$file"
  fi
}

# Use fd and fzf to get the args to a command.
# Works only with zsh
# Examples:
# f mv # To move files. You can write the destination after selecting the files.
# f 'echo Selected:'
# f 'echo Selected music:' --extention mp3
# fm rm # To rm files in current directory
f() {
    sels=( "${(@f)$(fd "${fd_default[@]}" "${@:2}"|fz)}" )
    test -n "$sels" && print -z -- "$1 ${sels[@]:q:q}"
}

# Like f, but not recursive.
fm() f "$@" --max-depth 1

# Deps
alias fz="fzf-noempty --bind 'tab:toggle,shift-tab:toggle+beginning-of-line+kill-line,ctrl-j:toggle+beginning-of-line+kill-line,ctrl-t:top' --color=light -1 -m"
fzf-noempty () {
	local in="$(</dev/stdin)"
	test -z "$in" && (
		exit 130
	) || {
		ec "$in" | fzf "$@"
	}
}
ec () {
	if [[ -n $ZSH_VERSION ]]
	then
		print -r -- "$@"
	else
		echo -E -- "$@"
	fi
}

# fd - cd to selected directory
fd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}

# fh - repeat history
fh() {
  print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed -r 's/ *[0-9]*\*? *//' | sed -r 's/\\/\\\\/g')
}

# fkill - kill process
fkill() {
  local pid
  pid=$(ps -ef |grep -v ^root | sed 1d | fzf -m | awk '{print $2}')

  if [ "x$pid" != "x" ]
  then
    echo $pid | xargs kill -${1:-9}
  fi
}

# tm - create new tmux session, or switch to existing one. Works from within tmux too. (@bag-man)
# `tm` will allow you to select your tmux session via fzf.
# `tm irc` will attach to the irc session (if it exists), else it will create it.

tm() {
  [[ -n "$TMUX" ]] && change="switch-client" || change="attach-session"
  if [ $1 ]; then
    tmux $change -t "$1" 2>/dev/null || (tmux new-session -d -s $1 && tmux $change -t "$1"); return
  fi
  session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --exit-0) &&  tmux $change -t "$session" || echo "No sessions found."
}

# fs [FUZZY PATTERN] - Select selected tmux session
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
fs() {
  local session
  session=$(tmux list-sessions -F "#{session_name}" | \
    fzf --query="$1" --select-1 --exit-0) &&
  tmux switch-client -t "$session"
}

unalias z 2> /dev/null
z() {
  [ $# -gt 0 ] && _z "$*" && return
  cd "$(_z -l 2>&1 | fzf --height 40% --nth 2.. --reverse --inline-info +s --tac --query "${*##-* }" | sed 's/^[0-9,.]* *//')"
}


#alias lp="lpass show -c --password $(lpass ls  | fzf | awk '{print $(NF)}' | sed 's/\]//g')"
gcbr() {
  result=$(git branch -a --color=always | grep -v '/HEAD\s' | sort |
    fzf --height 50% --border --ansi --tac --preview-window right:70% \
      --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1) | head -'$LINES |
    sed 's/^..//' | cut -d' ' -f1)

  if [[ $result != "" ]]; then
    if [[ $result == remotes/* ]]; then
      git checkout --track $(echo $result | sed 's#remotes/##')
    else
      git checkout "$result"
    fi
  fi
}

gfs() {
  git -c color.status=always status --short |
  fzf --height 50% --border --ansi --multi --ansi --nth 2..,.. \
    --preview '(git diff --color=always -- {-1} | sed 1,4d; cat {-1}) | head -500' |
  cut -c4- | sed 's/.* -> //'
}
