
if [[ -d "/usr/local/opt/gnu-getopt/bin" ]]; then
	PATH="/usr/local/opt/gnu-getopt/bin:$PATH"
fi

# $HOMEBREW_PREFIX is resolved in .zshrc, so this costs no `brew --prefix` fork.
[[ -n "$HOMEBREW_PREFIX" && -s "$HOMEBREW_PREFIX/etc/autojump.sh" ]] && . "$HOMEBREW_PREFIX/etc/autojump.sh"
