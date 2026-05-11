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

## pre-commit hook

`git/hooks/pre-commit` runs secretlint and gitleaks via Docker. After cloning, enable it with:

```bash
git config --local core.hooksPath git/hooks
```

- Requires `docker` (skipped if not installed)
- Skipped when `CI` env var is set
- Bypass with `git commit --no-verify`
