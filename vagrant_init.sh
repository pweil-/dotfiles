#!/bin/bash
cd ~
rm -Rf .vim
rm -Rf .vimrc
rm -Rf .bashrc

ln -s dotfiles/.vim .vim
ln -s dotfiles/.vimrc .vimrc
ln -s dotfiles/.bashrc_vagrant .bashrc

cd dotfiles
git remote set-url origin https://pweil-@github.com/pweil-/dotfiles.git

cd ~
source ~/.bashrc
