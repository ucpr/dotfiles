{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gh
    ripgrep
    fd
    jq
    fzf
    neovim
    tree
    delta
    ghq
    deno
    wget
    bun
  ];
}
