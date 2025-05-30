{
  description = "Jerome M1 configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, ... }:
  let
    username = "jerome";
    system = "aarch64-darwin"; # aarch64-darwin or x86_64-darwin
    hostname = "Jeromes-M1";
    configurationRevision = self.rev or self.dirtyRev or null;

  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {
      specialArgs = inputs // {
        inherit username hostname system configurationRevision;
      };
      system = system;
      modules = [
        ./config/configuration.nix
        ./config/host-user.nix
        home-manager.darwinModules.home-manager {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "before-hm";
            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
            extraSpecialArgs = {
              inherit username hostname;
            };
            users.${username} = import ./config/home.nix;
          };
        }
      ];
    };

    # nix code formatter
    formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;
  };
}
