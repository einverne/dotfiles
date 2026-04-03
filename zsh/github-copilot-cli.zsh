# `gh copilot` now launches the new Copilot CLI, so the old `gh copilot alias`
# init snippet prints an error during shell startup. Load aliases through the
# legacy gh-copilot extension when it is installed, and fall back to the old
# standalone binary only when that is available.
if command -v gh >/dev/null 2>&1 && gh extension list 2>/dev/null | grep -qE '^gh copilot[[:space:]]'; then
    eval "$(gh extension exec copilot alias -- zsh)"
elif command -v github-copilot-cli >/dev/null 2>&1; then
    eval "$(github-copilot-cli alias -- zsh)"
fi
