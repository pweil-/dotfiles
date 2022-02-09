#!/usr/bin/env bash

###
# Be sure to have added your git key in order to perform the clones below
# curl -sL -o ./setup-env.sh https://raw.githubusercontent.com/pweil-/dotfiles/master/setup-env.sh
# chmod 750 ./setup-env.sh
# ./setup-env.sh
###

set -eux -o pipefail

platform=$(uname)

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

cd ~/codebase
if [[ "$platform" != "Darwin" ]]; then
   git clone https://github.com/aruhier/gnome-terminal-colors-solarized.git
   gnome-terminal-colors-solarized/install.sh
else
   git clone https://github.com/tomislav/osx-terminal.app-colors-solarized
   echo "double click the terminal theme in order to install on mac"
fi

cd ~
