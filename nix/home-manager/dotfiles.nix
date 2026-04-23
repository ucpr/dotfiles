{ config, pkgs, ... }:
let
  dotfiles = "${config.home.homeDirectory}/.ghq/github.com/ucpr/dotfiles";
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";
in
{
  xdg.enable = true;

  # ~/.config/wezterm
  xdg.configFile."wezterm".source = link "wezterm";
  # ~/.config/nvim
  xdg.configFile."nvim".source = link "nvim";
  # ~/.config/git
  xdg.configFile."git".source = link "git";
  # ~/.gitconfig
  home.file.".gitconfig".source = link "git/.gitconfig";
  # ~/.gitmessage
  home.file.".gitmessage".source = link "git/.gitmessage";
  # ~/.config/sheldon
  xdg.configFile."sheldon".source = link "sheldon";
  # ~/.zshrc
  home.file.".zshrc".source = link "zsh/.zshrc";
  # ~/.config/zsh
  xdg.configFile."zsh".source = link "zsh";
  # ~/.config/mise
  xdg.configFile."mise".source = link "mise";
  # ~/.config/karabiner
  xdg.configFile."karabiner".source = link "karabiner";
  # ~/.config/aerospace
  xdg.configFile."aerospace".source = link "aerospace";
  # ~/.config/borders
  xdg.configFile."borders".source = link "borders";
  # ~/.config/claude
  # xdg.configFile."claude".source = link "claude";
}
