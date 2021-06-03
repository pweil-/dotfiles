#!/usr/bin/env bash

set -eux -o pipefail

# sudo dnf install -y git vim

mkdir ~/{bin,codebase}

###
# Gimmie
###
curl -sL -o ~/bin/gimme https://raw.githubusercontent.com/travis-ci/gimme/master/gimme
chmod +x ~/bin/gimme

###
# profile
###
cd ~/codebase
git clone git@github.com:pweil-/dotfiles.git

ln -s ~/codebase/dotfiles/.profile ~/.profile
echo "source ~/.profile" >> ~/.bashrc


###
# vim
###
ln -s ~/codebase/dotfiles/.vimrc ~/.vimrc
ln -s ~/codebase/dotfiles/.vim ~/.vim

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
echo "Be sure to run BundleInstall in vim"


###
# gnome terminal colors
###
cd ~/codebase
git clone https://github.com/aruhier/gnome-terminal-colors-solarized.git
gnome-terminal-colors-solarized/install.sh

cd ~
