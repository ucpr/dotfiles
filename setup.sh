#!/bin/sh

mkdir ~/.vim
mkdir ~/.config/nvim/

ln -s ./init.vim ~/.config/nvim/init.vim
ln -s ./toml ~/.vim/toml
ln -s ./.zshrc ~/.zshrc
ln -s ./.bash_aliases ~/.bash_aliases
ln -s ./.curlrc ~/.curlrc
ln -s ./.wgetrc ~/.wgetrc
ln -s ./.latexmkrc ~/.latexmkrc
ln -s ./.tmux.conf ~/.tmux.conf
ln -s ./.Xmodmap ~/.Xmodmap

# git
git config --global user.email "uchihara1229@gmail.com"
git config --global user.name "nve3pd"

# dein.vim
echo "install dein.vim"
mkdir -p ~/.vim/dein/repos/github.com/Shougo/dein.vim
git clone https://github.com/Shougo/dein.vim.git ~/.vim/dein/repos/github.com/Shougo/dein.vim

# Ubuntu
echo "$(uname -r)" | grep Ubuntu
if [ "$?" -eq 1 ]
then
  sudo apt install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev \
		libsqlite3-dev wget curl llvm libfreetype6-dev libblas-dev liblapack-dev gfortran tk-dev python3-tk
  sudo add-apt-repository ppa:neovim-ppa/unstable
  sudo add-apt-repository ppa:ubuntu-desktop/ubuntu-make
  sudo apt update -y
  sudo apt install -y neovim ubuntu-make zsh
fi
