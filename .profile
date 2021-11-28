#!/bin/bash

##################################################################################################
# global Linux items
##################################################################################################
platform=$(uname)
if [[ "$platform" != "Darwin" ]]; then
    ###
    # disable shortcuts that are used in IntelliJ's windows keymap since that is what I'm
    # most used to
    ###
    # alt+f1
    gsettings set org.gnome.desktop.wm.keybindings panel-main-menu "[]"
    # ctrl+alt+left
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-left "[]"
    # ctrl+alt+right
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-right "[]"

    #tweak fonts
    gsettings set org.gnome.settings-daemon.plugins.xsettings hinting "slight"
    gsettings set org.gnome.settings-daemon.plugins.xsettings antialiasing "rgba"
    # move buttons to the left
    # this can be done via gnome-tweak-tools now
    #gsettings set org.gnome.desktop.wm.preferences button-layout "close,minimize,maximize:"

    export JAVA_HOME=/etc/alternatives/java_sdk
    # this seems to have changed as of fc21
    export VAGRANT_DEFAULT_PROVIDER=virtualbox

    # this is only temporary and a bit annoying.  To make a permanent change you must
    # update /etc/modprobe.d/hid_apple.conf to have "options hid_apple fnmode=2"
    # and update initramfs using dracut -f.
    # see http://flavioleitner.blogspot.com/2016/12/apple-usb-keyboard-on-linux-fedora-25.html
    #
    #fnmode=$(cat /sys/module/hid_apple/parameters/fnmode)
    #if [[ "$fnmode" != "0" ]]; then
    #    echo "fixing apple keyboard with fnmode"
    #    0 = disable fn key, 1 = fn keys act as special keys, 2 = fn keys act as fn keys, press fn
    #    to use special keys
    #    sudo su -c "echo 2 > /sys/module/hid_apple/parameters/fnmode"
    #fi
else
    # ensure commands like mv include hidden files
    shopt -s dotglob
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
DEFAULT_GO_VER=1.16
eval "$(gimme $DEFAULT_GO_VER)" > /dev/null 2>&1


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

setupDevEnv () {
    ORG=$1
    BASE_PATH=$2
    GO_VER=$3

    eval "$(gimme $GO_VER)" > /dev/null 2>&1

    export GOPATH=~/codebase/${BASE_PATH}
    export CODE_ROOT=${GOPATH}/src/github.com/$ORG/$BASE_PATH
    export CODE_BIN=${CODE_ROOT}/_output/local/bin/linux/amd64
    export PATH=$PATH:/${CODE_BIN}

    alias cbc="cd $CODE_ROOT"
}

devMetering () {
    setupDevEnv kube-reporting metering-operator $DEFAULT_GO_VER
}

devOpenShift () {
    setupDevEnv openshift origin $DEFAULT_GO_VER

    export TEST_FILES=~/codebase/dotfiles/vagrantfiles/openshift

    if [[ "$platform" == "Darwin" ]]; then
        export OPENSHIFT_NUM_CPUS=$(sysctl -n hw.ncpu)
    else
        export OPENSHIFT_NUM_CPUS=8
    fi

    export OPENSHIFT_MEMORY=8192

    alias buildos="cbc; OS_BUILD_PLATFORMS='linux/amd64' make WHAT='cmd/oc cmd/openshift'"
    alias testos="cbc; hack/test-go.sh"
    alias cleanos="cbc; rm -Rf openshift.local.*"
    alias oss="sudo ${CODE_BIN}/openshift --loglevel=4 start --latest-images"

}

devInstaller () {
    setupDevEnv openshift intaller $DEFAULT_GO_VER
    export AWS_PROFILE=openshift-dev
    alias make="cbi && hack/build.sh"
}

setupOSEnv() {
   sudo chmod -R 777 ${OS_ROOT}/openshift.local.*
   export KUBECONFIG=${OS_ROOT}/openshift.local.config/master/admin.kubeconfig
}

devKube() {
    setupDevEnv k8s.io kubernetes $DEFAULT_GO_VER
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

devKCP() {
    KCP_GOPATH="kcp"
    export GOPATH=~/codebase/$KCP_GOPATH
    KCP_ROOT=$GOPATH/src/github.com/kcp-dev/kcp
    alias cbc="cd $KCP_ROOT"
    export KUBECONFIG=$KCP_ROOT/.kcp/admin.kubeconfig
    alias kcp-start="cd $KCP_ROOT && go run ./cmd/kcp start"
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

