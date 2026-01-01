{pkgs, ...}: {
  nix = {
    optimise.automatic = true;
    settings = {
      experimental-features = "nix-command flakes";
      max-jobs = 8;
    };
  };


  system = {
    stateVersion = 6;
    primaryUser = "ucpr";

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
    casks = [
      "1password"
      "1password-cli"
      "google-chrome"
      "google-japanese-ime"
      "google-cloud-sdk"
      "google-drive"
      "discord"
      "slack"
      "docker"
      "visual-studio-code"
      "spotify"
      "zoom"
      "wireshark"
      "wezterm"
      "notion"
      "notion-calendar"
      "rectangle"
      "karabiner-elements"
      "alfred"
    ];
  };
}
