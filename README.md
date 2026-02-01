<div align="center">
  <h1>dotfiles</h1>
</div>

## setup

```
$ git clone https://github.com/ucpr/dotfiles
$ cd ~/dotfiles
$ make setup
```

## Nix

```bash
sudo HOME=$HOME NIX_USER=username nix run nix-darwin -- switch --flake .#mac --impure
```
