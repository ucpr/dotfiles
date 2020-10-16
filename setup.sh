#!/bin/sh

cat << EOF

     _       _    __ _ _
  __| | ___ | |_ / _(_) | ___  ___
 / _  |/ _ \| __| |_| | |/ _ \/ __|
| (_| | (_) | |_|  _| | |  __/\__ \
 \__,_|\___/ \__|_| |_|_|\___||___/

  https://github.com/ucpr/dotfiles


EOF

# ------------------------- init ----------------------------- #

# Ubuntu
echo "$(cat /etc/issue)" | grep "Ubuntu"
if [ "$?" -eq 1 ]
then
  sudo apt update -y -q
  sudo apt upgrade -y -q
  sudo apt install -y -q build-essential curl vim zsh git
fi

# Archlinux
echo "$(cat /etc/issue)" | grep "Arch Linux"
if [ "$?" -eq 1 ]
then
  sudo pacman -Syu --noconfirm
  sudo pacman -S --noconfirm git vim zsh curl
fi

# ------------------------------------------------------------ #

# Create symbolic link
echo "Create symbolic link"
ln -s ~/.dotfiles/.zshrc ~/.zshrc
ln -s ~/.dotfiles/.tmux.conf ~/.tmux.conf
ln -s ~/.dotfiles/.Xmodmap ~/.Xmodmap
ln -s ~/.dotfiles/.vimrc ~/.vimrc
ln -s ~/.dotfiles/vim ~/.vim
ln -s ~/.dotfiles/nvim ~/.config/nvim
ln -s ~/.dotfiles/ranger ~/.config/ranger
ln -s ~/.dotfiles/ScreenLayout ~/.config/ScreenLayout
ln -s ~/.dotfiles/i3 ~/.config/i3
ln -s ~/.dotfiles/alacritty ~/.config/alacritty
ln -s ~/.dotfiles/polybar ~/.config/polybar

# Setting git
echo "Setting git"
git config --global user.email "contact@ucpr.dev"
git config --global user.name "ucpr"

# dein.vim
echo "Clone dein.vim"
mkdir -p ~/.vim/dein/repos/github.com/Shougo/dein.vim
git clone https://github.com/Shougo/dein.vim.git ~/.vim/dein/repos/github.com/Shougo/dein.vim

# Tmux Plugin Manager
echo "Clone Tmux Plugin Manager"
mkdir -p ~/.tmux/plugins
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# anyenv
echo "Clone anyenv"
git clone https://github.com/anyenv/anyenv ~/.anyenv
export PATH="$HOME/.anyenv/bin:$PATH"
anyenv init
anyenv install --init
