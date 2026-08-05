# Cached evaluation of expensive shell-integration generators.
#
# Tools like `gh copilot alias`, `pyenv init -`, `mise activate` and
# `atuin init zsh` each fork a binary that takes 10-800ms to print a chunk of
# shell code. That code only changes when the binary itself changes, so cache
# the output and re-run the generator only when the binary is newer.
#
# Run `zsh_cache_clear` to force a refresh.

ZSH_INIT_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh-init"
[[ -d $ZSH_INIT_CACHE_DIR ]] || mkdir -p $ZSH_INIT_CACHE_DIR

# zsh_cached_eval [-r <ref-file>] <cache-name> <command> [args...]
#
# Sources the cached stdout of <command>, regenerating it when the cache is
# missing/empty or older than <ref-file> (defaults to the <command> binary).
# Pass -r when <command> is a shell function, or when the freshness of the
# output depends on some other binary.
zsh_cached_eval() {
  local ref=
  if [[ $1 == -r ]]; then
    ref=$2
    shift 2
  fi

  local name=$1
  shift
  local cache=$ZSH_INIT_CACHE_DIR/$name.zsh
  [[ -n $ref ]] || ref=${commands[$1]}

  if [[ ! -s $cache || ( -n $ref && $ref -nt $cache ) ]]; then
    # Write via a temp file so an interrupted run never leaves a half-written
    # cache that would be sourced on the next startup.
    if "$@" >| $cache.$$ 2>/dev/null && [[ -s $cache.$$ ]]; then
      command mv -f $cache.$$ $cache
    else
      command rm -f $cache.$$
      return 1
    fi
  fi

  source $cache
}

zsh_cache_clear() {
  command rm -f $ZSH_INIT_CACHE_DIR/*.zsh(N)
  print "Cleared $ZSH_INIT_CACHE_DIR"
}
