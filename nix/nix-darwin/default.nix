{ pkgs, user, ... }: {
  users.users.${user} = {
    name = user;
    home = "/Users/${user}";
  };

  nix = {
    enable = false;  # Determinate Nix を使用するため無効化
  };

  services.tailscale.enable = false;

  system = {
    stateVersion = 6;
    primaryUser = user;

    defaults = {
      NSGlobalDomain = {
        KeyRepeat = 2;
        InitialKeyRepeat = 15;
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        AppleInterfaceStyle = "Dark";
        AppleShowScrollBars = "WhenScrolling";
        AppleEnableMouseSwipeNavigateWithScrolls = true;
        AppleEnableSwipeNavigateWithScrolls = true;
        NSAutomaticWindowAnimationsEnabled = false;
        NSWindowResizeTime = 0.001;
        NSDocumentSaveNewDocumentsToCloud = false;
        NSStatusItemSpacing = 2;
        NSTableViewDefaultSizeMode = 1;
        "com.apple.sound.beep.volume" = 0.001;
        "com.apple.trackpad.scaling" = 3.0;
      };
#      universalaccess = {
#        reduceMotion = true;
#      };
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
        expose-animation-duration = 0.0;
        show-recents = false;
        orientation = "bottom";
        tilesize = 32;
        wvous-bl-corner = 1;
        wvous-br-corner = 1;
        wvous-tl-corner = 1;
        wvous-tr-corner = 10;
        persistent-apps = [
          { app = "/Applications/Google\ Chrome.app"; }
          { app = "/Applications/Rex.app"; }
          { app = "/Applications/Slack.app"; }
        ];
      };
      CustomUserPreferences = {
        "com.apple.symbolichotkeys".AppleSymbolicHotKeys = {
          "60" = {
            enabled = true;
            value = {
              type = "standard";
              parameters = [ 32 49 524288 ];
            };
          };
          "64".enabled = false;
          "65".enabled = false;
        };
        "com.apple.HIToolbox" = {
          AppleFnUsageType = 1;
          AppleEnabledInputSources = [
            {
              InputSourceKind = "Keyboard Layout";
              "KeyboardLayout ID" = 252;
              "KeyboardLayout Name" = "ABC";
            }
            {
              "Bundle ID" = "com.apple.CharacterPaletteIM";
              InputSourceKind = "Non Keyboard Input Method";
            }
            {
              "Bundle ID" = "com.apple.PressAndHold";
              InputSourceKind = "Non Keyboard Input Method";
            }
            {
              "Bundle ID" = "com.apple.50onPaletteIM";
              InputSourceKind = "Non Keyboard Input Method";
            }
          ];
        };
        "com.apple.inputsources".AppleEnabledThirdPartyInputSources = [
          {
            "Bundle ID" = "com.google.inputmethod.Japanese";
            "Input Mode" = "com.apple.inputmethod.Japanese";
            InputSourceKind = "Input Mode";
          }
          {
            "Bundle ID" = "com.google.inputmethod.Japanese";
            InputSourceKind = "Keyboard Input Method";
          }
        ];
      };
    };

    activationScripts.postActivation.text = ''
      sudo -u ${user} /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';
  };

  fonts.packages = with pkgs; [
    jetbrains-mono
    biz-ud-gothic
  ];

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "uninstall";
    };
    taps = [
      "nikitabobko/tap"
      "FelixKratz/formulae"
    ];
    brews = [
      "tree-sitter-cli"
      "mise"
      "sheldon"
      "git-lfs"
      "k1LoW/tap/mo"
      # "container"
    ];
    extraConfig = ''
      brew "FelixKratz/formulae/borders", trusted: true
    '';
    casks = [
      "1password"
      "1password-cli"
      "google-chrome"
      "google-japanese-ime"
      "google-drive"
      "gcloud-cli"
      "discord"
      "slack"
      "docker-desktop"
      "visual-studio-code"
      "spotify"
      "wireshark-app"
      "notion"
      "notion-calendar"
      "karabiner-elements"
      "alfred"
      "craft"
      "claude"
      "nani"
      "homerow"
      "chatgpt"
      "nikitabobko/tap/aerospace"
      "codex"
      "flutter"
      "claude-code"
    ];
  };
}
