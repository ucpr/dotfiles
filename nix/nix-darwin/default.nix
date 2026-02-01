{ pkgs, user, ... }: {
  users.users.${user} = {
    name = user;
    home = "/Users/${user}";
  };

  nix = {
    enable = false;  # Determinate Nix を使用するため無効化
  };

  system = {
    stateVersion = 6;
    primaryUser = user;

    defaults = {
      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        AppleInterfaceStyle = "Dark";
        AppleShowScrollBars = "WhenScrolling";
        AppleEnableMouseSwipeNavigateWithScrolls = true;
        AppleEnableSwipeNavigateWithScrolls = true;
        NSDocumentSaveNewDocumentsToCloud = false;
        NSStatusItemSpacing = 2;
        NSTableViewDefaultSizeMode = 1;
        "com.apple.sound.beep.volume" = 0.001;
        "com.apple.trackpad.scaling" = 3.0;
      };
      ".GlobalPreferences" = {
        "com.apple.mouse.scaling" = 1.0;
      };
      LaunchServices = {
        LSQuarantine = true;
      };
      WindowManager = {
        StandardHideDesktopIcons = true;
      };
      controlcenter = {
        BatteryShowPercentage = true;
        Sound = true;
      };
      menuExtraClock = {
        Show24Hour = true;
        ShowAMPM = false;
        ShowDate = 0;
        ShowDayOfWeek = true;
        ShowSeconds = true;
      };
      screencapture = {
        include-date = false;
      };
      finder = {
        AppleShowAllFiles = true;
        AppleShowAllExtensions = true;
        FXEnableExtensionChangeWarning = true;
        FXPreferredViewStyle = "Flwv";
        FXRemoveOldTrashItems = true;
        ShowExternalHardDrivesOnDesktop = false;
        ShowHardDrivesOnDesktop = false;
        ShowMountedServersOnDesktop = false;
        ShowPathbar = true;
        ShowStatusBar = true;
        _FXShowPosixPathInTitle = true;
      };
      dock = {
        autohide = true;
        autohide-delay = 1.0;
        autohide-time-modifier = 1.0;
        show-recents = false;
        orientation = "bottom";
        tilesize = 32;
        wvous-bl-corner = 1;
        wvous-br-corner = 1;
        wvous-tl-corner = 1;
        wvous-tr-corner = 10;
        persistent-apps = [
          { app = "/Applications/Google\ Chrome.app"; }
          { app = "/Applications/WezTerm.app"; }
          { app = "/Applications/Slack.app"; }
        ];
      };
    };
  };

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "uninstall";
    };
    brews = [
      "tree-sitter-cli"
      "mise"
      "sheldon"
    ];
    casks = [
      "1password"
      "1password-cli"
      "codex"
      "google-chrome"
      "google-japanese-ime"
      "google-drive"
      "gcloud-cli"
      "discord"
      "slack"
      "docker-desktop"
      "visual-studio-code"
      "spotify"
      "zoom"
      "wireshark-app"
      "wezterm"
      "notion"
      "notion-calendar"
      "rectangle"
      "karabiner-elements"
      "alfred"
      "font-jetbrains-mono"
    ];
  };
}
