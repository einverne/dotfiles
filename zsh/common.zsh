
setopt histignorealldups sharehistory


# Keep history within the shell and save it to ~/.zsh_history:
HISTSIZE=10000
SAVEHIST=$HISTSIZE
HISTFILE=~/.zsh_history

setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.

