#!/bin/bash

##################################################################################################
# global Linux items
##################################################################################################
platform=$(uname)
if [[ "$platform" != "Darwin" ]]; then
    #disable alt+f1 shortcut for fedora setup
    gsettings set org.gnome.desktop.wm.keybindings panel-main-menu "[]"
    #tweak fonts
    gsettings set org.gnome.settings-daemon.plugins.xsettings hinting "slight"
    gsettings set org.gnome.settings-daemon.plugins.xsettings antialiasing "rgba"
    # move buttons to the left
    gsettings set org.gnome.desktop.wm.preferences button-layout "close,minimize,maximize:"

    export JAVA_HOME=/etc/alternatives/java_sdk
    # this seems to have changed as of fc21
    export VAGRANT_DEFAULT_PROVIDER=virtualbox

    #fnmode=$(cat /sys/module/hid_apple/parameters/fnmode)

    #if [[ "$fnmode" != "0" ]]; then
    #    echo "fixing apple keyboard with fnmode"
    #    sudo su -c "echo 0 > /sys/module/hid_apple/parameters/fnmode"
    #fi
fi
##################################################################################################

##################################################################################################
# random setup items
##################################################################################################
if [[ -f ~/git-completion.bash ]]; then
    source ~/git-completion.bash
fi

# include homedir bin
if [[ -d ~/bin ]]; then
    export PATH=$PATH:~/bin
fi

# Global go path for installing "normal" things.  Dev projects have their
# own gopath setup
export GOPATH=~/codebase/go
export PATH=$PATH:~/codebase/go/bin
eval "$(gimme 1.11.2)" > /dev/null 2>&1


##################################################################################################
# aliases
##################################################################################################
alias ll='ls -al'
alias l='ls'
alias profile='vi ~/.profile'
alias sop="source ~/.profile"
alias vi=vim
alias vimrc='vi ~/.vimrc'
alias cb="cd ~/codebase"
alias gl="git log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
##################################################################################################

devTwoBook () {
    # mamp php version
    export PATH=/Applications/MAMP/bin/php/php5.3.27/bin:$PATH
    export PATH=/Applications/MAMP/Library/bin:$PATH


    alias phpini='vi /Applications/MAMP/bin/php/php5.3.27/conf/php.ini'
    alias vhosts='vi /Applications/MAMP/conf/apache/extra/httpd-vhosts.conf'
    alias httpdc='vi /Applications/MAMP/conf/apache/httpd.conf'
    alias nginxc='vi /usr/local/etc/nginx/nginx.conf'
    alias fpmc='sudo vi /etc/php-fpm.conf'

    ###
    # work aliases
    ###
    alias start="sudo /Applications/MAMP/bin/apache2/bin/apachectl -f /Applications/MAMP/conf/apache/httpd.conf -k start; /Applications/MAMP/bin/startMysql.sh"

    alias stop="sudo /Applications/MAMP/bin/apache2/bin/apachectl stop; /Applications/MAMP/bin/stopMysql.sh"

    alias db="mysql -u root -proot"

    alias cb="cd ~/codebase/twobook_git/twobook_naansense"
    alias cbb="cd ~/codebase/twobook_naansense/branches"
    alias cbg="cd ~/codebase/git/dotfiles"

    alias phplog="tail -f /Applications/MAMP/logs/php_error.log"

    alias nglog="tail -f /usr/local/var/log/nginx/error.log"

    alias fpm="sudo php-fpm -c /Applications/MAMP/bin/php/php5.3.27/conf/php.ini"
    alias rnginx="sudo nginx -s reload"

    alias tbv="cb; cd etc/vagrant-prod"
    alias tbu="tbv; vagrant resume"
    alias tbd="tbv; vagrant suspend"
    alias tbb="tbv; vagrant ssh beanstalk"
    alias tbdb="tbv; vagrant ssh db"
    alias tbw="tbv; vagrant ssh web-1"
    alias tbn="tbv; vagrant ssh lb"

    #Git stuff
    alias restash="cb; git checkout etc/vagrant-prod/Vagrantfile src/application/config/database.php src/scripts/server_setup/setup/nginx/development/default.conf"
    alias unstash="git stash apply stash@{0}"
    alias gu="restash; git checkout master; git svn rebase; unstash"

}

devOpenShift () {
    OS_GOPATH="openshift"
    #eval "$(gimme 1.9)"
    export OS_ROOT=~/codebase/${OS_GOPATH}/src/github.com/openshift/origin
    export OS_BIN=${OS_ROOT}/_output/local/bin/linux/amd64
    export GOPATH=~/codebase/${OS_GOPATH}
    export PATH=$PATH:${OS_BIN}

    export TEST_FILES=~/codebase/dotfiles/vagrantfiles/openshift

    if [[ "$platform" == "Darwin" ]]; then
        export OPENSHIFT_NUM_CPUS=$(sysctl -n hw.ncpu)
    else
        export OPENSHIFT_NUM_CPUS=8
    fi

    export OPENSHIFT_MEMORY=8192

    alias cbo='cd ${OS_ROOT}'
    alias buildos="cbo; OS_BUILD_PLATFORMS='linux/amd64' make WHAT='cmd/oc cmd/openshift'"
    alias testos="cbo; hack/test-go.sh"
    alias cleanos="cbo; rm -Rf openshift.local.*"
    alias oss="sudo ${OS_BIN}/openshift --loglevel=4 start --latest-images"

}

setupOSEnv() {
   sudo chmod -R 777 ${OS_ROOT}/openshift.local.*
   export KUBECONFIG=${OS_ROOT}/openshift.local.config/master/admin.kubeconfig
}

devKube() {
    KUBE_GOPATH="kubernetes"
    #eval "$(gimme 1.10)"

    if [[ "$platform" == "Darwin" ]]; then
        alias kubevm="cd ~/codebase/dotfiles/vagrantfiles/k8s" 
    fi

    export KUBE_ROOT=~/codebase/${KUBE_GOPATH}/src/k8s.io/kubernetes
    export GOPATH=~/codebase/${KUBE_GOPATH}
    alias cbk="cd $KUBE_ROOT"
    # add etcd to the path, required for local clusters
    export PATH=~/bin:${KUBE_ROOT}/_output/local/bin/linux/amd64:${KUBE_ROOT}/third_party/etcd:/usr/local/go/bin:$PATH
    export TEST_FILES=~/codebase/dotfiles/kube_temp
    export KUBERNETES_PROVIDER=local

    if [[ -d /opt/google-cloud-sdk ]]; then
        source '/opt/google-cloud-sdk/path.bash.inc'
        source '/opt/google-cloud-sdk/completion.bash.inc'
        export KUBE_GCE_INSTANCE_PREFIX=pweil-e2e
    fi

    alias luc="sudo PATH=$PATH -E hack/local-up-cluster.sh"
    alias lucpsp="RUNTIME_CONFIG="extensions/v1beta1=true,extensions/v1beta1/podsecuritypolicy=true" luc"
    alias kc=kubectl
}

setupKubeEnv() {
    cluster/kubectl.sh config set-cluster local --server=http://127.0.0.1:8080 --insecure-skip-tls-verify=true
    cluster/kubectl.sh config set-context local --cluster=local
    cluster/kubectl.sh config use-context local
}

devKubeDoc() {
    alias cbk="cb: cd kubernetes.github.io"
    alias kubedoc="cbk; docker run -ti --rm -v "$PWD":/k8sdocs -p 4000:4000 pweil/k8sdocs"
}


devImageInspector() {
    II_GOPATH="image-inspector"
    export II_ROOT=~/codebase/${II_GOPATH}/src/github.com/openshift/${II_GOPATH}
    export GOPATH=~/codebase/${II_GOPATH}
    alias cbi="cd $II_ROOT"
}

devACS() {
    ACSENGINE_GOPATH="acs-engine"
    export ACSENGINE_ROOT="~/codebase/${ACSENGINE_GOPATH}/src/github.com/Azure/${ACSENGINE_GOPATH}"
    export GOPATH=~/codebase/${ACSENGINE_GOPATH}
    export PATH=$GOPATH/bin:$PATH:${ACSENGINE_ROOT}/bin
    alias cba="cd $ACSENGINE_ROOT"
    export AZURE_PROFILE=redhat
}

devOSA() {
    ACSENGINE_GOPATH="openshift-azure"
    export ACSENGINE_ROOT="~/codebase/${ACSENGINE_GOPATH}/src/github.com/openshift/${ACSENGINE_GOPATH}"
    export GOPATH=~/codebase/${ACSENGINE_GOPATH}
    export PATH=$GOPATH/bin:$PATH:${ACSENGINE_ROOT}/bin
    # add dev oc to the path for commands and add the default kubeconfig
    export PATH=$PATH:~/codebase/openshift/src/github.com/openshift/origin/_output/local/bin/linux/amd64
    export KUBECONFIG=${ACSENGINE_ROOT}/_data/_out/admin.kubeconfig
    alias cbo="cd $ACSENGINE_ROOT && . ./env"
    export AZURE_PROFILE=redhat
}

dockerClear() {
    docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)
}

dockerClearImages() {
    dockerClear
    docker rmi $(docker images -q)
}

niceEtcd(){
    curl -L -s "${1}" | python -m json.tool
}

