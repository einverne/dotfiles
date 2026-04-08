#!/bin/bash
# Copy stdin (or argv) to the clipboard.
# Prefer native clipboard tools for local sessions and fall back to OSC 52 so
# remote tmux sessions can still copy back to the outer terminal.

set -euo pipefail

if [ -t 0 ]; then
    input="${*:-}"
else
    input=$(cat)
fi

copy_with_native_clipboard() {
    if [ -n "${SSH_CONNECTION:-}" ] || [ -n "${SSH_CLIENT:-}" ] || [ -n "${SSH_TTY:-}" ]; then
        return 1
    fi

    if command -v pbcopy >/dev/null 2>&1; then
        printf %s "$input" | pbcopy
        return 0
    fi

    if [ -n "${WAYLAND_DISPLAY:-}" ] && command -v wl-copy >/dev/null 2>&1; then
        printf %s "$input" | wl-copy
        return 0
    fi

    if [ -n "${DISPLAY:-}" ] && command -v xclip >/dev/null 2>&1; then
        printf %s "$input" | xclip -in -selection clipboard
        return 0
    fi

    if [ -n "${DISPLAY:-}" ] && command -v xsel >/dev/null 2>&1; then
        printf %s "$input" | xsel --clipboard --input
        return 0
    fi

    return 1
}

build_osc52_sequence() {
    local len max_len encoded

    len=$(printf %s "$input" | wc -c | tr -d ' ')
    max_len=100000
    if [ "$len" -gt "$max_len" ]; then
        echo "Input is too long for OSC 52 (max $max_len bytes)" >&2
        exit 1
    fi

    encoded=$(printf %s "$input" | base64 | tr -d '\r\n')
    printf '\033]52;c;%s\007' "$encoded"
}

write_osc52() {
    local osc52 target client_tty pane_tty passthrough

    osc52=$(build_osc52_sequence)

    if [ -n "${TMUX:-}" ]; then
        client_tty=$(tmux display-message -p '#{client_tty}' 2>/dev/null || true)
        pane_tty=$(tmux display-message -p '#{pane_tty}' 2>/dev/null || true)

        if [ -n "$client_tty" ] && [ -w "$client_tty" ]; then
            printf %s "$osc52" > "$client_tty"
            return 0
        fi

        target=${pane_tty:-/dev/tty}
        passthrough=${osc52//$'\033'/$'\033\033'}
        printf '\033Ptmux;\033%s\033\\' "$passthrough" > "$target"
        return 0
    fi

    printf %s "$osc52" > /dev/tty
}

copy_with_native_clipboard || write_osc52
