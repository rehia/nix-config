{ ... }:

{
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };

    taps = [
      "confluentinc/confluent-hub-client"
      "rtk-ai/tap"
    ];

    casks = [
      "confluent-hub-client"
      "docker-desktop"
      "miro"
      "notion"
      "numi"
      "puremac"
    ];

    brews = [
      "difftastic"
      "rtk"
    ];
  };
}
