# https://sw.kovidgoyal.net/kitty/faq.html#i-get-errors-about-the-terminal-being-unknown-or-opening-the-terminal-failing-when-sshing-into-a-different-computer
#alias ssh="kitty +kitten ssh"
alias k="kubectl"
alias tmux="TERM=screen-256color tmux -2"
alias vi="vim"
#alias ls="exa"
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

alias proxy='export http_proxy=http://127.0.0.1:1080 https_proxy=http://127.0.0.1:1080 all_proxy=socks5://127.0.0.1:1080'
alias unproxy='unset http_proxy;unset https_proxy;unset all_proxy'
alias proxy_http='export all_proxy=http://127.0.0.1:1081'

# assh
# https://github.com/moul/assh
if [[ -f ~/.ssh/assh.yml ]]; then
	alias ssh="assh wrapper ssh --"
fi

alias pstop='watch "ps aux | sort -nrk 3,3 | head -n 5"'
if command -v gh &> /dev/null && gh extension list 2>/dev/null | grep -q copilot
then
	eval "$(gh copilot alias -- zsh)"
fi

alias qs='open -a QSpace'

# AI CLI tools with permission skip
alias cc='claude --dangerously-skip-permissions'
alias ge='gemini --yolo'
alias cx='codex --dangerously-bypass-approvals-and-sandbox'
