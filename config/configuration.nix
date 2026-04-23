{ pkgs, username, system, configurationRevision, ... }:

{
  system.primaryUser = username;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  nix.gc = {
    automatic = true;
    interval = { Weekday = 0; Hour = 2; Minute = 0; };
    options = "--delete-older-than 30d";
  };

  nix.optimise.automatic = true;

  # Enable alternative shell support in nix-darwin.
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableFzfCompletion = true;
    enableFzfGit = true;
    enableFzfHistory = true;
  };

  system = {
    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    stateVersion = 5;

    configurationRevision = configurationRevision;

    defaults = {
      dock = {
        autohide = true;
        mru-spaces = false;
      };
      NSGlobalDomain = {
        InitialKeyRepeat = 15;
        KeyRepeat = 2;
      };
    };
  };

  environment = {
    shells = [ pkgs.zsh ];

    systemPackages = with pkgs; [
      vim
      git
      fzf
      zsh-fast-syntax-highlighting
      iterm2
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
  security.pam.services.sudo_local.touchIdAuth = true;

  # The platform the configuration will be used on.
  nixpkgs = {
    hostPlatform = system;
    config.allowUnfree = true;
  };
}
