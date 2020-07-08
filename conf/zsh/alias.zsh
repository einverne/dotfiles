alias tmux="TERM=screen-256color tmux -2"
alias vi="vim"
alias mux="TERM=screen-256color tmuxinator"
#alias ls="ls -alh"
alias cp="cp -i"
alias df="df -h"
alias free="free -m"
alias grep="grep --color=auto"
alias open="xdg-open"
alias ag="ag -i"
alias mkdir="mkdir -p"
alias e=$EDITOR

alias mci="mvn -e -U clean install"

# https://stackoverflow.com/a/15503178/1820217
alias gitlog="git ls-files -z | xargs -0n1 git blame -w --show-email | perl -n -e '/^.*?\((.*?)\s+[\d]{4}/; print $1,"\n"' | sort -f | uniq -c | sort -n"

