# You may need to manually set your language environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export EDITOR=vim
#export TERM="screen-256color"
export MISE_DATA_DIR="${MISE_DATA_DIR:-$HOME/.local/share/mise}"

_dotfiles_tool_root() {
  local tool="$1"
  command -v mise >/dev/null 2>&1 || return 1
  mise where "$tool" 2>/dev/null
}

case $OSTYPE in
	darwin*)
		export ANDROID_HOME="$HOME/Library/Android/sdk"
		export PATH="$PATH:$ANDROID_HOME/platform-tools"
	;;
	linux*)
		export ANDROID_HOME="$HOME/Android/Sdk"
	;;
esac

export PATH="$PATH:$ANDROID_HOME/bin/"

export GOKU_EDN_CONFIG_FILE="$HOME/dotfiles/karabiner/karabiner.edn"

export PATH="/opt/homebrew/sbin:$PATH"
export PATH="/usr/local/sbin:$PATH"

export PATH="$HOME/.local/bin:$PATH"
# eval "$(zoxide init zsh)"

if [[ -d $HOME/.pyenv ]]; then
    # pyenv
	export PYENV_ROOT="$HOME/.pyenv"
	export PATH="$PYENV_ROOT/bin:$PATH"
	if command -v pyenv 1>/dev/null 2>&1; then
		eval "$(pyenv init -)"
		# eval "$(pyenv init --path)"
		eval "$(pyenv virtualenv-init -)"
	fi
fi

if [[ -d $HOME/.poetry/bin ]]; then
	# poetry
	export POETRY_ROOT="$HOME/.poetry/bin"
	export PATH="$POETRY_ROOT:$PATH"
fi

if [[ -d /home/linuxbrew/.linuxbrew ]]; then
	eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
fi

# Pin Flutter SDK env vars to the mise-managed 3.35 stable toolchain.
_dotfiles_flutter_root="$(_dotfiles_tool_root flutter@3.35.0-stable 2>/dev/null)"
if [[ -n "$_dotfiles_flutter_root" ]]; then
  export FLUTTER_ROOT="$_dotfiles_flutter_root"
fi
unset _dotfiles_flutter_root

# if [[ -d ~/.jenv ]]; then
#     # jenv
#     export PATH="$HOME/.jenv/bin:$PATH"
#     eval "$(jenv init -)"
# fi

_dotfiles_java_home="$(_dotfiles_tool_root java 2>/dev/null)"
if [[ -n "$_dotfiles_java_home" ]]; then
	export JAVA_HOME="$_dotfiles_java_home"
fi
unset _dotfiles_java_home

# Maven
_dotfiles_maven_home="$(_dotfiles_tool_root maven mvn 2>/dev/null)"
if [[ -n "$_dotfiles_maven_home" ]]; then
	export M2_HOME="$_dotfiles_maven_home"
	export M2="$M2_HOME/bin"
    export PATH="$M2:$PATH"
fi
unset _dotfiles_maven_home


# Hive
if [[ -d "$HOME/apache-hive-2.3.4-bin" ]]; then
    export HIVE_HOME=$HOME/apache-hive-2.3.4-bin
    export PATH=$PATH:$HIVE_HOME/bin
    export CLASSPATH=$CLASSPATH:$HIVE_HOME/lib/*:.
fi

# Hadoop
if [[ -d "$HOME/hadoop/hadoop-2.9.1" ]]; then
    export HADOOP_HOME=$HOME/hadoop/hadoop-2.9.1
    export HADDOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
    export HADOOP_SSH_OPTS="-p 222"

    export HADOOP_MAPRED_HOME=$HADOOP_HOME
    export HADOOP_COMMON_HOME=$HADOOP_HOME

    export HADOOP_HDFS_HOME=$HADOOP_HOME
    export YARN_HOME=$HADOOP_HOME
    export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
    export HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib/native"

    export PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin
    export HADOOP_INSTALL=$HADOOP_HOME

    export CLASSPATH=$CLASSPATH:$HADOOP_HOME/lib/*:.
fi

export GPG_TTY=$(tty)

if [[ -d ~/.rbenv/ ]]; then
    # rbenv
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)"
    export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"
fi

if [[ -d /usr/local/go ]]; then
    export PATH="$PATH:/usr/local/go/bin"
    export GOROOT="/usr/local/go"
fi

if [[ -d /opt/homebrew/opt/php@8.1 ]]; then
  export PATH="/opt/homebrew/opt/php@8.1/bin:$PATH"
  export PATH="/opt/homebrew/opt/php@8.1/sbin:$PATH"
fi

if [[ -d $HOME/.cargo ]]; then
	export PATH="$PATH:$HOME/.cargo/bin"
fi

if [[ -d $HOME/.kube ]]; then
    export KUBECONFIG=~/.kube/config
    for kubeconfig_file in "$HOME/.kube/configs/"*.yaml; do
        export KUBECONFIG="$KUBECONFIG:$kubeconfig_file"
    done
fi

if [[ -d /usr/lib/dart/bin ]]; then
	export PATH="$PATH:/usr/lib/dart/bin"
fi

if [[ -d $HOME/Library/Application\ Support/JetBrains/Toolbox/scripts ]]; then
	export PATH=$PATH:$HOME/Library/Application\ Support/JetBrains/Toolbox/scripts/
fi

[[ -d /usr/local/opt/gnu-sed/libexec/gnubin ]] && export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"

if [[ -d $HOME/Sync/beancount ]]; then
	export BEANCOUNT_ROOT=$HOME/Sync/beancount
fi


[[ -e "$HOME/lib/oracle-cli/lib/python3.6/site-packages/oci_cli/bin/oci_autocomplete.sh" ]] && source "$HOME/lib/oracle-cli/lib/python3.6/site-packages/oci_cli/bin/oci_autocomplete.sh"

export PATH="$HOME/.fly/bin:$PATH"

if [[ -d /opt/homebrew ]]; then
  export LIBRARY_PATH=$LIBRARY_PATH:/opt/homebrew/lib/
  export CPATH=$CPATH:/opt/homebrew/include/
fi

# Added by Antigravity
[[ -d "$HOME/.antigravity/antigravity/bin" ]] && export PATH="$HOME/.antigravity/antigravity/bin:$PATH"

if [ -f $HOME/.env ]; then
    set -a
    source $HOME/.env
    set +a
fi
