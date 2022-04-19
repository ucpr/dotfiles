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

# For Linux
if [ -e "/etc/issue" ]; then
  # Ubuntu
  echo "$(cat /etc/issue)" | grep "Ubuntu"
  if [ "$?" -eq 1 ]; then
    sudo apt update -y -q
    sudo apt upgrade -y -q
    sudo apt install -y -q build-essential curl zsh git
  fi

  # Archlinux
  echo "$(cat /etc/issue)" | grep "Arch Linux"
  if [ "$?" -eq 1 ]; then
    sudo pacman -Syu --noconfirm
    sudo pacman -S --noconfirm git vim zsh curl
  fi
fi

# For Mac
if (type "sw_vers" > /dev/null 2>&1); then
  echo "$(sw_vers)" | grep "macOS"
  if [ "$?" -eq 1 ]; then
    # ここに初期化処理
    echo ""
  fi
fi

# ---------------------- Functions -------------------------- #

create_symbolic_link() {
  echo "Create symbolic link"
  if [ -e ~/.config ]; then
    echo "exist ~/.config"
  else
    mkdir ~/.config
    mkdir ~/.config/zsh
  fi

  ln -s `pwd`/common/.vimrc ~/.vimrc
  ln -s `pwd`/common/nvim ~/.config/nvim
  ln -s `pwd`/common/.zshrc ~/.zshrc
  ln -s `pwd`/common/zsh/plugin.zsh ~/.config/zsh/plugin.zsh
  ln -s `pwd`/common/.tmux.conf ~/.tmux.conf
  ln -s `pwd`/common/.gitconfig ~/.gitconfig
  ln -s `pwd`/common/.gitmessage ~/.gitmessage

  echo "Done"
}

install_dein_vim() {
  echo "Clone dein.vim"

  if [ -e ~/.cache/dein/repos/github.com/Shougo/dein.vim ]; then
    echo "exist ~/.cache/dein/repos/github.com/Shougo/dein.vim "
  else
    mkdir -p ~/.cache/dein/repos/github.com/Shougo/dein.vim
  fi
  git clone https://github.com/Shougo/dein.vim.git ~/.cache/dein/repos/github.com/Shougo/dein.vim

  echo "Done"
}

# ------------------------------------------------------------ #

# symbolic link
read -p "Do you wish to create symbolic links? (y/n)" yn
case $yn in
    [Yy]* ) create_symbolic_link;;
    [Nn]* ) echo "Skip";;
    * ) echo "Please answer yes or no.";;
esac

# dein.vim
read -p "Do you wish to install dein.vim? (y/n)" yn
case $yn in
    [Yy]* ) install_dein_vim;;
    [Nn]* ) echo "Skip";;
    * ) echo "Please answer yes or no.";;
esac


echo "ALL DONE"
