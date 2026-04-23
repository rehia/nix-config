{ pkgs, username, lib, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {
    packages = with pkgs; [
      kubectx
      kubectl
      (google-cloud-sdk.withExtraComponents [google-cloud-sdk.components.gke-gcloud-auth-plugin])
      sshuttle
      bat
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
      python313Packages.numpy
      cocogitto
      jq
      yq
      glow
      gh
      navi
      erlang_27
      elixir_1_17
      mas
      grpcurl
      libfido2
      openssh
      claude-code
      railway
      postgresql_18
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
    stateVersion = "25.11";

    shellAliases = {
      ll = "ls -lah";
      update = "sudo darwin-rebuild switch --flake ~/.config/nix";
      pg-prod = "pgcli -h 127.0.0.1 -p 5434 -U sql-ro@sunday-production.iam";
      pg-rw-prod = "pgcli -h 127.0.0.1 -p 5434 -U sql-rw@sunday-production.iam";
      pg-alpha = "pgcli -h 127.0.0.1 -p 5434 -U sql-rw@sunday-alpha.iam";
    };

    activation = {
      activateUserSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        echo "Activating user settings..."
        /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
      '';
      linkIterm = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        mkdir -p ~/Applications
        ln -sf ${pkgs.iterm2}/Applications/iTerm.app ~/Applications/iTerm.app
      '';
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

      initContent = ''
        bindkey "^[f" forward-word
        bindkey "^[b" backward-word
        # not the same code for left and right arrows in iTerm than in Mac OS terminal
        bindkey "^[[1;3C" forward-word
        bindkey "^[[1;3D" backward-word

        [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

        if [ -f "$HOME/sunday/tools/google-cloud-sdk/completion.zsh.inc" ]; then
          . "$HOME/sunday/tools/google-cloud-sdk/completion.zsh.inc"
        fi

        source "$HOME/.support-tools/install/support-tools-rc.sh"
      '';
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    # thefuck = {
    #   enable = true;
    #  enableZshIntegration = true;
    # };

    vscode = {
      enable = true;
      profiles.default.extensions = with pkgs.vscode-extensions; [
        eamodio.gitlens
        vscodevim.vim
        elixir-lsp.vscode-elixir-ls
        ms-azuretools.vscode-docker
        ms-vscode-remote.remote-containers
      ];
    };
  };

  targets.darwin.defaults = {
    NSGlobalDomain = {
      AppleInterfaceStyleSwitchesAutomatically = true;
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
    };

    "com.googlecode.iterm2" = {
      AlternateMouseScroll = true;
      CopySelection = true;
    };
  };
}
