import glob
import os
import platform
import subprocess
import shutil


dotfiles = glob.glob(".*")
dotfiles.remove(".git")
dotfiles.remove(".bashrc")


def init_ubuntu():
    subprocess.run(["sudo", "apt", "update"])
    subprocess.run(["sudo", "apt", "upgrade"])
    subprocess.run("sudo apt install make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libfreetype6-dev libblas-dev liblapack-dev gfortran tk-dev python3-dev python3-tk git zsh ruby-dev".split())
    subprocess.run(["sudo", "add-apt-repository", "ppa:ubuntu-desktop/ubuntu-make"])
    subprocess.run(["sudo", "apt", "update"])
    subprocess.run(["sudo", "apt", "install", "ubuntu-make"])
    subprocess.run(["LANG=C xdg-user-dirs-gtk-update"])  # フォルダ名を日本語から英語に


def vim():
    n = input("vim or neovim?[vim/nvim] ")

def main():
    for f in dotfiles:
        if os.path.exists("~/" + f):
            n = input("The file already exists.\nDo you want to overwrite?[y/n] ")
            if n != "n":
                shutil.move(f, os.path.expanduser("~"))
                print(f + " moved to home dir")
        else:
            shutil.copy(f, os.path.expanduser("~"))
            print(f + " moved to home dir")


    if "Ubuntu" in platform.dist():
        init_ubuntu()
    subprocess.run(["git", "clone", "git clone https://github.com/riywo/anyenv ~/.anyenv"])
    subprocess.run([])


if __name__ == "__main__":
    main()
