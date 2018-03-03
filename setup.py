import glob
import os
import platform
import subprocess
import shutil


dotfiles = glob.glob(".*")
dotfiles.remove(".git")
dotfiles.remove(".bashrc")
dotfiles.remove(".vimrc")


def init_ubuntu():
    subprocess.run(["sudo", "apt", "update"])
    subprocess.run(["sudo", "apt", "upgrade"])
    subprocess.run("sudo apt install make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libfreetype6-dev libblas-dev liblapack-dev gfortran tk-dev python3-dev python3-tk git zsh ruby-dev".split())
    subprocess.run(["sudo", "add-apt-repository", "ppa:ubuntu-desktop/ubuntu-make"])
    subprocess.run(["sudo", "apt", "update"])
    subprocess.run(["sudo", "apt", "install", "ubuntu-make"])
    subprocess.run(["LANG=C xdg-user-dirs-gtk-update"])  # フォルダ名を日本語から英語に


def vim():
    # install dein.vim
    subprocess.run(["mkdir", "-p", "~/.vim/dein/repos/github.com/Shougo/dein.vim"])
    subprocess.run(["git", "clone", "https://github.com/Shougo/dein.vim.git", "~/.vim/dein/repos/github.com/Shougo/dein.vim"])

    n = input("vim or neovim?[vim/nvim] ")
    if n == "vim":  # vim
        shutil.copy(".vimrc", os.path.expanduser("~"))
        shutil.move("toml", os.path.join(os.path.expanduser("~"), ".vim"))
    else:  # neovim
        nvim_path = os.path.join(os.path.expanduser("~"), ".config", "nvim")
        if not os.path.exists(nvim_path):
            os.mkdir(nvim_path)
        shutil.copy(".vimrc", nvim_path + "/init.vim")
        shutil.move("toml", os.path.join(os.path.expanduser("~"), "/.vim"))


def main():
    for f in dotfiles:
        if os.path.exists(os.path.join(os.path.expanduser("~"), f)):
            n = input("The file already exists.\nDo you want to overwrite?[y/n] ")
            if n != "n":
                shutil.copy(f, os.path.expanduser("~"))
                print(f + " moved to home dir")
        else:
            shutil.copy(f, os.path.expanduser("~"))
            print(f + " moved to home dir")

    if "Ubuntu" in platform.dist():
        init_ubuntu()
    vim()  # setting vim
    subprocess.run(["git", "clone", "git clone https://github.com/riywo/anyenv ~/.anyenv"])


if __name__ == "__main__":
    main()
