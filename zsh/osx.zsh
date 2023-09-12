
if [[ -d $HOME/.asdf/ ]]; then
	. $HOME/.asdf/asdf.sh
	. $HOME/.asdf/completions/asdf.bash
fi

if [[ -d "/usr/local/opt/gnu-getopt/bin" ]]; then
	PATH="/usr/local/opt/gnu-getopt/bin:$PATH"
fi

[[ -s `brew --prefix`/etc/autojump.sh ]] && . `brew --prefix`/etc/autojump.sh