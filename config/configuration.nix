{ pkgs, system, configurationRevision, ... }:

{
  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Enable alternative shell support in nix-darwin.
  # programs.fish.enable = true;
  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      # enableFastSyntaxHighlighting = true;
      enableFzfCompletion = true;
      enableFzfGit = true;
      enableFzfHistory = true;
    };
  };

  homebrew = {
    enable = true;

    taps = [
      "confluentinc/confluent-hub-client"
      "homebrew/bundle"
    ];

    casks = [
      "confluent-hub-client"
      "docker"
      "miro"
      "notion"
    ];

    brews = [
      "difftastic"
    ];

    # masApps = {
    # };
  };

  system = {
    # activationScripts are executed every time you boot the system or run `nixos-rebuild` / `darwin-rebuild`.
    activationScripts.postUserActivation.text = ''
      # activateSettings -u will reload the settings from the database and apply them to the current session,
      # so we do not need to logout and login again to make the changes take effect.
      /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';

    defaults = {
      NSGlobalDomain = {
        AppleInterfaceStyleSwitchesAutomatically = true;
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
      };
    };

    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    stateVersion = 5;

    configurationRevision = configurationRevision;
  };

  environment = {
    shells = [
      pkgs.zsh
    ];

    systemPackages = [
      pkgs.vim
      pkgs.git
      pkgs.fzf
      pkgs.zsh-fast-syntax-highlighting
      pkgs.iterm2
    ];
  };

  fonts.packages = with pkgs; [
    material-design-icons
    font-awesome
    nerd-fonts.agave
    nerd-fonts.code-new-roman
    nerd-fonts.intone-mono
    nerd-fonts.symbols-only
  ];

  # unlock sudo commands with fingerprint
  security.pam.enableSudoTouchIdAuth = true;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = system;
}
