sudo dnf update -y kernel*
sudo shutdown -r now
sudo dnf clean all
sudo dnf group install -y "Development Tools"

mkdir -p /home/vagrant/codebase
mkdir -p /home/vagrant/bin

curl -sL -o /home/vagrant/bin/gimme https://raw.githubusercontent.com/travis-ci/gimme/master/gimme
chmod +x /home/vagrant/bin/gimme

gimme 1.8

ln -s /home/vagrant/codebase/dotfiles/.profile /home/vagrant/.profile
ln -s /home/vagrant/codebase/dotfiles/.vim /home/vagrant/.vim
ln -s /home/vagrant/codebase/dotfiles/.vimrc /home/vagrant/.vimrc

echo "source ~/.profile" >> /home/vagrant/.bashrc

sudo dnf install -y git docker golang golang-race make gcc zip mercurial krb5-devel bsdtar bc rsync 
sudo dnf install -y bind-utils file jq createrepo openssl gpgme gpgme-devel libassuan libassuan-devel wget perl vim

sudo dnf clean all

sudo systemctl enable docker
sudo systemctl start docker
sudo chgrp vagrant /var/run/docker.sock

docker pull openshift/origin-base
docker pull openshift/origin-pod
docker pull openshift/origin-docker-registry
docker pull openshift/origin-deployer
docker pull openshift/origin-haproxy-router
docker pull openshift/origin-logging-auth-proxy
docker pull openshift/ruby-20-centos7
docker pull openshift/hello-openshift

