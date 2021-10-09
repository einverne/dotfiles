# You may need to manually set your language environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8


export EDITOR=vim
#export TERM="screen-256color"

export NODE_HOME=/usr/local/node-v6.11.4-linux-64/
export PATH="$NODE_HOME/bin/:$PATH"

if [[ -d $HOME/phabricator/ ]]; then
	export PATH="$PATH:$HOME/phabricator/arcanist/bin/"
fi

case $OSTYPE in
	darwin*)
		export ANDROID_HOME="$HOME/Library/Android/sdk"
	;;
	linux*)
		export ANDROID_HOME="$HOME/Android/Sdk"
	;;
esac

export PATH="$PATH:$ANDROID_HOME/bin/"

export GOKU_EDN_CONFIG_FILE="$HOME/dotfiles/karabiner/karabiner.edn"

export PATH="/usr/local/sbin:$PATH"

eval "$(zoxide init zsh)"
export PATH="$HOME/.local/bin:$PATH"


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

if [[ -d /home/linuxbrew/.linuxbrew ]]; then
	eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
fi

if [[ -d $HOME/flutter ]]; then
	export PATH="$PATH:$HOME/flutter/flutter_sdk/bin"
fi

# if [[ -d ~/.jenv ]]; then
#     # jenv
#     export PATH="$HOME/.jenv/bin:$PATH"
#     eval "$(jenv init -)"
# fi

# JDK
if [[ -d "/usr/local/jdk1.8.0_131" ]]; then
    export JAVA_HOME=/usr/local/jdk1.8.0_131
    export PATH=$PATH:$JAVA_HOME/bin/
fi
if [[ -d "$HOME/.asdf/installs/java/adoptopenjdk-8.0.265+1/" ]]; then
	export JAVA_HOME=$HOME/.asdf/installs/java/adoptopenjdk-8.0.265+1/
	export PATH=$PATH:$JAVA_HOME/bin/
fi
# . ~/.asdf/plugins/java/set-java-home.zsh
# if [[ -d "/Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home/" ]]; then
# 	export JAVA_HOME=/Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home/
# 	export PATH=$PATH:$JAVA_HOME/bin/
# fi
# export JAVA_HOME="$HOME/.jenv/versions/`jenv version-name`"

if [[ -d "~/.asdf/plugins/java/" ]]; then
	. ~/.asdf/plugins/java/set-java-home.zsh
fi

# Maven
if [[ -d "/opt/maven" ]]; then
    export M2_HOME=/opt/maven
    export M2=$M2_HOME/bin
    export PATH=$M2:$PATH
fi
if [[ -d "$HOME/.asdf/installs/maven/3.6.3" ]]; then
	export M2_HOME=$HOME/.asdf/installs/maven/3.6.3
	export M2=$H2_HOME/bin
    export PATH=$M2:$PATH
fi

# Tomcat
if [[ -d "/opt/tomcat" ]]; then
    export CATALINA_HOME=/opt/tomcat/
    export PATH=$CATALINE_HOME:$PATH
fi

#
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

# Derby
if [[ -d "$HOME/db-derby-10.14.2.0-bin" ]]; then
    export DERBY_HOME=$HOME/db-derby-10.14.2.0-bin
    export PATH=$PATH:$DERBY_HOME/bin

    export CLASSPATH=$CLASSPATH:$DERBY_HOME/lib/derby.jar:$DERBY_HOME/lib/derbytools.jar
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

if [[ -d $HOME/dotnet ]]; then
	export DOTNET_ROOT=$HOME/dotnet
	export PATH=$PATH:$DOTNET_ROOT
fi

if [[ -d $HOME/go ]]; then
	export GOPATH=$HOME/go
	export PATH="$PATH:$GOPATH/bin"
fi

if [[ -d $HOME/.cargo ]]; then
	export PATH="$PATH:$HOME/.cargo/bin"
fi

if [[ -d /usr/lib/dart/bin ]]; then
	export PATH="$PATH:/usr/lib/dart/bin"
fi

if [[ -d $HOME/.asdf/installs/rust/1.51.0/bin ]]; then
	export PATH="$PATH:$HOME/.asdf/installs/rust/1.51.0/bin"
fi

export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"

if [[ -d $HOME/Sync/beancount ]]; then
	export BEANCOUNT_ROOT=$HOME/Sync/beancount
fi
