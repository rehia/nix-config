{ pkgs, username, lib, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {
    packages = with pkgs; [
      htop
      starship
      kubectx
      (google-cloud-sdk.withExtraComponents [google-cloud-sdk.components.gke-gcloud-auth-plugin])
      sshuttle
      bat
      thefuck
      google-cloud-sql-proxy
      csvkit
      redis
      (dbt.withAdapters (adapters: [ adapters.dbt-bigquery adapters.dbt-postgres ]))
      stack
      cmake
      mob
      protobuf
      protoc-gen-grpc-web
      pgcli
      python310Packages.numpy
      cocogitto
      jq
      yq
      glow
      gh
      navi
      erlang_27
      elixir_1_16
    ];

    username = username;
    homeDirectory = "/Users/${username}";

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "24.11";

    shellAliases = {
      ll = "ls -lah";
    };
  };

  # Let Home Manager install and manage itself.
  programs = {
    home-manager.enable = true;

    htop = {
      enable = true;
      settings = {
        show_program_path = true;
      };
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
      settings = builtins.fromTOML ( builtins.readFile ./starship.toml );
    };

    zsh = {
      enable = true;
      enableCompletion = true;

      oh-my-zsh = {
        enable = true;
        plugins = [
          "dirhistory"
          "git"
          "fzf"
          "jsontools"
          "kubectl"
          "nvm"
          # "nix-zsh-completions"
          "ohmyzsh-full-autoupdate"
          "sudo"
          "zsh-autosuggestions"
          "zsh-syntax-highlighting"
        ];
      };

      sessionVariables = {
        SDKMAN_DIR = "$HOME/.sdkman";
        NVM_DIR = "$HOME/.nvm";
        CHECKOUT_REPOSITORIES_PATH = "~/sunday/";
        EDITOR = "vim";
      };

      initExtra = ''
        [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

        if [ -f '/Users/jerome/sunday/tools/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/jerome/sunday/tools/google-cloud-sdk/completion.zsh.inc'; fi

        source /Users/jerome/.support-tools/install/support-tools-rc.sh ## ADDED BY SUPPORT TOOLS
      '';
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    thefuck = {
      enable = true;
      enableZshIntegration = true;
    };

  };

  targets.darwin.defaults = {
    "com.googlecode.iterm2" = {
      AlternateMouseScroll = true;
      CopySelection = true;
    };
  };
}
