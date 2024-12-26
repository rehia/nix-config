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

    # zsh = { already done in system configuration
      # enable = true;
      #enableCompletion = true;
      # enableFastSyntaxHighlighting = true;
      # enableFzfCompletion = true;
      # enableFzfGit = true;
      # enableFzfHistory = true;
    # };
  };
}
