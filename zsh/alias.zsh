# https://sw.kovidgoyal.net/kitty/faq.html#i-get-errors-about-the-terminal-being-unknown-or-opening-the-terminal-failing-when-sshing-into-a-different-computer
alias ssh="kitty +kitten ssh"
alias tmux="TERM=screen-256color tmux -2"
alias vi="vim"
alias ls="exa"
alias cd="z"
alias mux="TERM=screen-256color tmuxinator"
#alias ls="ls -alh"
alias cp="cp -i"
alias df="df -h"
alias free="free -m"
alias grep="grep --color=auto"
# alias open="xdg-open"
alias ag="ag -i"
alias mkdir="mkdir -p"
alias e=$EDITOR

alias mci="mvn -e -U clean install"
alias mcp="mvn -U clean package"
alias mvn-purge="mvn dependency:purge-local-repository"

# https://stackoverflow.com/a/15503178/1820217
alias gitlog="git ls-files -z | xargs -0n1 git blame -w --show-email | perl -n -e '/^.*?\((.*?)\s+[\d]{4}/; print $1,"\n"' | sort -f | uniq -c | sort -n"

alias proxy='export all_proxy=socks5://127.0.0.1:1080'
alias unproxy='unset all_proxy'
alias proxy_http='export all_proxy=http://127.0.0.1:1081'

# assh
# https://github.com/moul/assh
if [[ -f ~/.ssh/assh.yml ]]; then
	alias ssh="assh wrapper ssh --"
fi
