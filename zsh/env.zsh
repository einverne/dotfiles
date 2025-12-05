# You may need to manually set your language environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export EDITOR=vim
#export TERM="screen-256color"

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

if [[ -d $HOME/.asdf ]]; then
    export ASDF_DATA_DIR="$HOME/.asdf"
    export PATH="$ASDF_DATA_DIR/shims:$PATH"
fi

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

if [[ -d $HOME/.poetry ]]; then
	# poetry
	export POETRY_ROOT="$HOME/.poetry/bin"
	export PATH="$POETRY_ROOT:$PATH"
fi

if [[ -d /home/linuxbrew/.linuxbrew ]]; then
	eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
fi

if [[ -d $HOME/flutter ]]; then
	export PATH="$PATH:$HOME/flutter/flutter_sdk/bin"
fi

export FLUTTER_ROOT=/Users/einverne/.asdf/installs/flutter/3.24.3-stable

# if [[ -d ~/.jenv ]]; then
#     # jenv
#     export PATH="$HOME/.jenv/bin:$PATH"
#     eval "$(jenv init -)"
# fi

# JDK
#if [[ -d "$HOME/.asdf/installs/java/" ]]; then
#	export JAVA_HOME=$HOME/.asdf/installs/java/adoptopenjdk-17.0.6+10/
#	export PATH=$PATH:$JAVA_HOME/bin/
#fi
# . ~/.asdf/plugins/java/set-java-home.zsh
# if [[ -d "/Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home/" ]]; then
# 	export JAVA_HOME=/Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home/
# 	export PATH=$PATH:$JAVA_HOME/bin/
# fi
# export JAVA_HOME="$HOME/.jenv/versions/`jenv version-name`"

if [[ -d "$HOME/.asdf/plugins/java/" ]]; then
	. $HOME/.asdf/plugins/java/set-java-home.zsh
fi

# Maven
if [[ -d "$HOME/.asdf/installs/maven/3.6.3" ]]; then
	export M2_HOME=$HOME/.asdf/installs/maven/3.6.3
	export M2=$H2_HOME/bin
    export PATH=$M2:$PATH
fi


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

if [[ -d ~/.nvm ]]; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
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

if [[ -d $HOME/.asdf/installs/rust/1.81.0/bin ]]; then
	export PATH="$PATH:$HOME/.asdf/installs/rust/1.81.0/bin"
fi

if [[ -d $HOME/Library/Application\ Support/JetBrains/Toolbox/scripts ]]; then
	export PATH=$PATH:$HOME/Library/Application\ Support/JetBrains/Toolbox/scripts/
fi

export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"

if [[ -d $HOME/Sync/beancount ]]; then
	export BEANCOUNT_ROOT=$HOME/Sync/beancount
fi


[[ -e "/home/einverne/lib/oracle-cli/lib/python3.6/site-packages/oci_cli/bin/oci_autocomplete.sh" ]] && source "/home/einverne/lib/oracle-cli/lib/python3.6/site-packages/oci_cli/bin/oci_autocomplete.sh"

export PATH="$HOME/.poetry/bin:$PATH"
export PATH="$HOME/.fly/bin:$PATH"

export LIBRARY_PATH=$LIBRARY_PATH:/opt/homebrew/lib/
export CPATH=$CPATH:/opt/homebrew/include/

# Added by Antigravity
export PATH="/Users/einverne/.antigravity/antigravity/bin:$PATH"

if [ -f $HOME/.env ]; then
    set -a
    source $HOME/.env
    set +a
fi
