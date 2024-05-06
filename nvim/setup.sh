mkdir -p ~/.cache/dpp/repos/github.com/
cd ~/.cache/dpp/repos/github.com/

mkdir Shougo
mkdir vim-denops

cd ./Shougo
git clone https://github.com/Shougo/dpp.vim

git clone https://github.com/Shougo/dpp-ext-installer
git clone https://github.com/Shougo/dpp-protocol-git
git clone https://github.com/Shougo/dpp-ext-lazy
git clone https://github.com/Shougo/dpp-ext-toml

cd ../vim-denops
git clone https://github.com/vim-denops/denops.vim
