#!/bin/bash

platform=$(uname)

if [[ -f ~/git-completion.bash ]]; then
    source ~/git-completion.bash
fi

if [[ "$platform" != "Darwin" ]]; then
    ######################
    # global Linux only items go here
    ######################

    #disable alt+f1 shortcut for fedora setup
    gsettings set org.gnome.desktop.wm.keybindings panel-main-menu "[]"
    #tweak fonts
    gsettings set org.gnome.settings-daemon.plugins.xsettings hinting "slight"
    gsettings set org.gnome.settings-daemon.plugins.xsettings antialiasing "rgba"
    #adjust the mac monitor to be less bright (no gui controls)
    #xrandr --output DP-0 --brightness 0.9

    export JAVA_HOME=/etc/alternatives/java_sdk
    # this seems to have changed as of fc21
    export VAGRANT_DEFAULT_PROVIDER=virtualbox

    #fnmode=$(cat /sys/module/hid_apple/parameters/fnmode)

    #if [[ "$fnmode" != "0" ]]; then
    #    echo "fixing apple keyboard with fnmode"
    #    sudo su -c "echo 0 > /sys/module/hid_apple/parameters/fnmode"
    #fi
else 
    ####################
    # Global OSX items go here
    ####################

    # The new golang plugin of intellij will map the gopath to global libraries in the project automatically.
    # This means that I can't use a single gopath and configure the projects nicely for IntelliSense while using
    # the latest alpha plugin.  These aliases help setup the env prior to launching intellij.
    alias ij="open -a /Applications/IntelliJ\ IDEA\ 14.app/"
    alias oij="devOpenShift;ij"
    alias kij="devKube;ij"
fi

###
# Other global items that aren't os specific
###
export PATH=/usr/local/go/bin:$PATH

# for vim-go tools we will add this directory to the path if it exists
# if you are setting up vim for the first time for go then create this directory and
# run GoInstallBinaries
if [[ -d ~/codebase/vim-go-workspace/bin ]]; then
    export PATH=~/codebase/vim-go-workspace/bin:$PATH
fi


setupAliases () {
    ###
    # shell command aliases
    ###
    alias ll='ls -al'
    alias l='ls'

    ###
    # editing aliases
    ###
    alias profile='vi ~/.profile'
    alias sop="source ~/.profile"


    alias vi=vim

    alias vimrc='vi ~/.vimrc'

    alias cb="cd ~/codebase"
    alias svns="svn status"

}

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

gitSetup () {
    alias gl="git log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
}

devGoTools() {
    export PATH=$PATH:~/codebase/gotools/bin
}

devOpenShift () {
    OS_GOPATH="openshift"
    export OS_ROOT=~/codebase/${OS_GOPATH}/src/github.com/openshift/origin
    export OS_BIN=${OS_ROOT}/_output/local/bin/linux/amd64
    export GOPATH=${OS_ROOT}/Godeps/_workspace:~/codebase/${OS_GOPATH}
    export PATH=$PATH:~/bin:$GOPATH/bin:${OS_BIN}:/opt/etcd:~/codebase/gotools/bin
    export OPENSHIFT_MEMORY=4096
    export OPENSHIFT_NUM_CPUS=8

    alias cbo='cd ${OS_ROOT}'
    alias buildos="cbo; make clean && make"
    alias testos="cbo; hack/test-go.sh"
    alias cleanos="cbo; rm -Rf openshift.local.*"
    alias oss="sudo ${OS_BIN}/openshift --loglevel=4 start"

}

setupOSEnv() {
   sudo chmod -R 777 ${OS_ROOT}/openshift.local.*
   export KUBECONFIG=${OS_ROOT}/openshift.local.config/master/admin.kubeconfig
}

devKube() {
    KUBE_GOPATH="kubernetes"

    if [[ "$platform" == "Darwin" ]]; then
        alias kubevm="cd ~/codebase/dotfiles/vagrantfiles/k8s" 
    fi

    export KUBE_ROOT=~/codebase/${KUBE_GOPATH}/src/k8s.io/kubernetes
    export GOPATH=${KUBE_ROOT}/Godeps/_workspace:~/codebase/${KUBE_GOPATH}
    alias cbk="cd $KUBE_ROOT"
    # add etcd to the path, required for local clusters
    export PATH=/opt/etcd:$PATH

    if [[ -d /opt/google-cloud-sdk ]]; then
        source '/opt/google-cloud-sdk/path.bash.inc'
        source '/opt/google-cloud-sdk/completion.bash.inc'
        export KUBE_GCE_INSTANCE_PREFIX=pweil-e2e
    fi

    alias luc="sudo PATH=$PATH -E hack/local-up-cluster.sh"
    alias kc="$KUBE_ROOT/cluster/kubectl.sh"
}

setupKubeEnv() {
    cluster/kubectl.sh config set-cluster local --server=http://127.0.0.1:8080 --insecure-skip-tls-verify=true
    cluster/kubectl.sh config set-context local --cluster=local
    cluster/kubectl.sh config use-context local
}

devRebase() {
    export GOPATH=~/codebase/rebase
    export PATH=${GOPATH}/bin:${PATH}
    alias rebaseInit="cb;rm -Rf rebase;mkdir rebase;go get github.com/tools/godep; go get github.com/openshift/origin; go get github.com/GoogleCloudPlatform/kubernetes;cd ${GOPATH}/src/github.com/GoogleCloudPlatform/kubernetes; git checkout master; git pull; git checkout -b stable_proposed; echo 'Rebase initialized and stable_proposed created'"
    alias cbk="cd ${GOPATH}/src/github.com/GoogleCloudPlatform/kubernetes"
    alias cbo="cd ${GOPATH}/src/github.com/openshift/origin"
}

oskill() {
    ps -ef | grep "openshift start" | grep -v grep | awk '{ print $2 }' | xargs kill
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


setupAliases
gitSetup

###
# setup the correct dev env here
###
#devTwoBook
#devGoLangTutorial
#devOpenShift
devGoTools

