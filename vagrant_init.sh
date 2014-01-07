#!/bin/bash
cd ~
rm -Rf .vim
rm -Rf .vimrc
rm -Rf .bashrc

git clone https://github.com/pweil-/dotfiles.git

ln -s dotfiles/.vim .vim
ln -s dotfiles/.vimrc .vimrc
ln -s dotfiles/.bashrc .bashrc

cd dotfiles
git remote set-url origin https://pweil-@github.com/pweil-/dotfiles.git

cd ~

