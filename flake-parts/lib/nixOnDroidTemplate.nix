{
  inputs,
  system,
  hostName,
  extraConfig,
  users,
  lib,
}: let
  inherit (inputs) nixpkgs nix-on-droid home-manager homeManagerModules droidModules;
  pkgs = import nixpkgs {
    system = "aarch64-linux";
    overlays = [nix-on-droid.overlays.default];
  };
  specialArgs = {inherit inputs system pkgs users hostName;};
in
  nix-on-droid.lib.nixOnDroidConfiguration {
    inherit system specialArgs;
    modules =
      [
        droidModules.fuyuNoKosei
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            backupFileExtension = "bak";
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = specialArgs;
            # Iterates over a list of users provided in the function call
            users = lib.attrsets.genAttrs users (user: {
              imports = [homeManagerModules.fuyuNoKosei];
              config.home.username = user;
            });
          };
        }
      ]
      ++ extraConfig;
  }
