###
# update kernel modules then installed the guest additions from
# http://download.virtualbox.org/virtualbox/5.0.40/
# https://www.vagrantup.com/docs/virtualbox/boxes.html
###
sudo dnf update -y kernel*
sudo shutdown -r now
sudo dnf group install -y "Development Tools"

# do additions install


###
# as the vagrant user do this
###
# setup home dir
mkdir -p /home/vagrant/codebase
mkdir -p /home/vagrant/bin

curl -sL -o /home/vagrant/bin/gimme https://raw.githubusercontent.com/travis-ci/gimme/master/gimme
chmod +x /home/vagrant/bin/gimme

gimme 1.8

ln -s /home/vagrant/codebase/dotfiles/.profile /home/vagrant/.profile
ln -s /home/vagrant/codebase/dotfiles/.vim /home/vagrant/.vim
ln -s /home/vagrant/codebase/dotfiles/.vimrc /home/vagrant/.vimrc

echo "source ~/.profile" >> /home/vagrant/.bashrc

# install dependencies
sudo dnf install -y git docker


sudo dnf install -y golang golang-race make gcc zip mercurial krb5-devel bsdtar bc rsync bind-utils file jq createrepo openssl gpgme gpgme-devel libassuan libassuan-devel wget perl

sudo dnf clean all
