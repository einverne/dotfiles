if command -v 1github-copilot-cli > /dev/null 2>&1; then
    eval "$(github-copilot-cli alias -- "$0")"
fi
