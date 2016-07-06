#!/bin/bash
if [[ -d /data/src/github.com/openshift/origin ]]; then
  ORIGIN_BASE=/data/src/github.com/openshift/origin
else 
  ORIGIN_BASE=/vagrant
fi

ORIGIN_BIN=${ORIGIN_BASE}/_output/local/bin/linux/amd64

export PATH=${ORIGIN_BIN}:${PATH}

alias cbo="cd ${ORIGIN_BASE}"
alias oss="sudo ${ORIGIN_BIN}/openshift --loglevel=4 start --latest-images=true --volume-dir=/tmp/origin.local.volumes --etcd-dir=/tmp/origin.local.etcd"
alias aes="sudo ${ORIGIN_BIN}/atomic-enterprise --loglevel=4 start --latest-images=true --volume-dir=/tmp/origin.local.volumes"
#alias linkos="ln -s ${ORIGIN_BASE}/_output/local/bin/linux/amd64/openshift ${ORIGIN_BASE}/_output/local/bin/linux/amd64/osc"
alias buildos="cbo; make clean && make; linkos"
alias cleanos="cbo; rm -Rf origin.local.*"
alias cleard='docker rm -f $(docker ps -a -q)'
alias clearimg='docker rmi -f $(docker images -q)'
alias fullBuild='hack/build-release.sh && hack/build-base-images.sh && hack/build-images.sh && make clean && make'
alias rebuildRouter="make && cp ${ORIGIN_BIN}/openshift images/router/haproxy/bin/. && docker build -t openshift/origin-haproxy-router  images/router/haproxy"

###
# Setup the env for working with openshift
###
setupEnv() {
   export KUBECONFIG=${ORIGIN_BASE}/openshift.local.config/master/admin.kubeconfig
}
  
