# You may need to manually set your language environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8


export EDITOR=vim
#export TERM="screen-256color"

export NODE_HOME=/usr/local/node-v6.11.4-linux-64/
export PATH="$NODE_HOME/bin/:$PATH"

export PATH="$PATH:$HOME/phabricator/arcanist/bin/"
export ANDROID_HOME="$HOME/Android/Sdk"
export PATH="$PATH:$ANDROID_HOME/bin/"

if [[ -d ~/.pyenv ]]; then
    # pyenv
    export PATH="$HOME/.pyenv/bin:$PATH"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
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
# export JAVA_HOME="$HOME/.jenv/versions/`jenv version-name`"

# Maven
if [[ -d "/opt/maven" ]]; then
    export M2_HOME=/opt/maven
    export M2=$M2_HOME/bin
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

