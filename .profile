platform=$(uname)

if [[ "$platform" != "Darwin" ]]; then
    ######################
    # global Linux only items go here
    ######################

    #disable alt+f1 shortcut for fedora setup
    gsettings set org.gnome.desktop.wm.keybindings panel-main-menu "[]"

    fnmode=$(cat /sys/module/hid_apple/parameters/fnmode)

    if [[ "$fnmode" != "0" ]]; then
        echo "fixing apple keyboard with fnmode"
        sudo su -c "echo 0 > /sys/module/hid_apple/parameters/fnmode"
    fi
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

devOpenShift () {
    OS_GOPATH="openshiftgo"

    if [[ "$platform" == "Darwin" ]]; then
        OS_GOPATH="openshift"
    fi

    export OS_ROOT=~/codebase/${OS_GOPATH}/src/github.com/openshift/origin
    export OS_BIN=${OS_ROOT}/_output/local/go/bin
    export GOPATH=${OS_ROOT}/Godeps/_workspace:~/codebase/${OS_GOPATH}
    export PATH=$PATH:~/bin:$GOPATH/bin:/usr/local/go/bin:${OS_BIN}:/opt/etcd

    alias cbo='cd ${OS_ROOT}'
    alias buildos="cbo; make clean && make; linkos"
    alias cleanos="cbo; rm -Rf openshift.local.*"
    alias oss="openshift start"

}

setupOSEnv() {
   sudo chmod a+r ${OS_ROOT}/openshift.local.certificates/admin/*
   export KUBECONFIG=${OS_ROOT}/openshift.local.certificates/admin/.kubeconfig
}

devKube() {
    KUBE_GOPATH="openshiftgo"

    if [[ "$platform" == "Darwin" ]]; then
        KUBE_GOPATH="kubernetes"
        alias kubevm="cd /Users/pweil/IdeaProjects/kubernetes"
    fi

    export KUBE_ROOT=~/codebase/${KUBE_GOPATH}/src/github.com/GoogleCloudPlatform/kubernetes
    export GOPATH=${KUBE_ROOT}/Godeps/_workspace:~/codebase/${KUBE_GOPATH}
    alias cbk="cd $KUBE_ROOT"
    alias kubecfg="$KUBE_ROOT/cluster/kubecfg.sh"

    echo "Warning: an alias to kubecfg has been created.  If you are trying to start a vagrant cluster this could"
    echo "cause an issue.  Unalias kubecfg before starting the cluster"
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



