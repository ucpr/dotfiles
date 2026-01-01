{ config, pkgs, user, ... }:

{
  home.username = user;
  home.homeDirectory = "/Users/${user}";
  home.stateVersion = "24.11";

  imports = [
    ./packages.nix
    ./dotfiles.nix
  ];

  programs.home-manager.enable = true;
}
