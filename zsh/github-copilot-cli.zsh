# `gh copilot` now launches the new Copilot CLI, so the old `gh copilot alias`
# init snippet prints an error at shell startup. Load the aliases through the
# legacy gh-copilot extension if it is installed, and fall back to the old
# standalone binary if only that is available.
#
# Probing the extension list costs ~200ms and generating the aliases another
# ~800ms, so the result is cached and only refreshed when the binary changes.
_copilot_aliases() {
    # Always emit something so an install without Copilot still caches, rather
    # than re-probing `gh extension list` on every startup.
    print '# gh copilot aliases'
    if command -v gh >/dev/null 2>&1 && gh extension list 2>/dev/null | grep -qE '^gh copilot[[:space:]]'; then
        gh extension exec copilot alias -- zsh
    elif command -v github-copilot-cli >/dev/null 2>&1; then
        github-copilot-cli alias -- zsh
    fi
}

zsh_cached_eval -r "${commands[gh]:-$commands[github-copilot-cli]}" \
    copilot-aliases _copilot_aliases
unset -f _copilot_aliases
