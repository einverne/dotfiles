
if [[ -d "/usr/local/opt/gnu-getopt/bin" ]]; then
	PATH="/usr/local/opt/gnu-getopt/bin:$PATH"
fi

[[ -s `brew --prefix`/etc/autojump.sh ]] && . `brew --prefix`/etc/autojump.sh
