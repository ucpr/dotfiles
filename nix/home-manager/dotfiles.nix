{ config, pkgs, ... }:
{
  xdg.enable = true;

  # ~/.config/wezterm
  xdg.configFile."wezterm".source = ../../wezterm;
  # ~/.config/nvim
  xdg.configFile."nvim".source = ../../nvim;
  # ~/.config/git
  xdg.configFile."git".source = ../../git;
  # ~/.gitconfig
  home.file.".gitconfig".source = ../../git/.gitconfig;
  # ~/.gitmessage
  home.file.".gitmessage".source = ../../git/.gitmessage;
  # ~/.config/sheldon
  xdg.configFile."sheldon".source = ../../sheldon;
  # ~/.zshrc
  home.file.".zshrc".source = ../../zsh/.zshrc;
  # ~/.config/zsh
  xdg.configFile."zsh".source = ../../zsh;
  # ~/.config/mise
  xdg.configFile."mise".source = ../../mise;
  # ~/.config/karabiner
  xdg.configFile."karabiner".source = ../../karabiner;
  # ~/.config/claude
  # xdg.configFile."claude".source = ../../claude;
}
