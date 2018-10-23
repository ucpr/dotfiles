#!/bin/sh

mkdir ~/.vim
mkdir ~/.config/nvim/

cp ./init.vim ~/.config/nvim/init.vim
cp -r ./toml ~/.vim/toml
cp ./.zshrc ~/.zshrc
cp ./.bash_aliases ~/.bash_aliases
cp ./.curlrc ~/.curlrc
cp ./.wgetrc ~/.wgetrc
cp ./.latexmkrc ~/.latexmkrc
cp ./.tmux.conf ~/.tmux.conf
cp ./.Xmodmap ~/.Xmodmap

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
