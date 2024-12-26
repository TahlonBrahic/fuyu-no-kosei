{
  inputs,
  pkgs,
  system,
  hostName,
  extraConfig,
  users,
  lib,
  overlays,
}: let
  inherit (inputs) home-manager homeManagerModules nixosModules;
  specialArgs = {inherit inputs system pkgs overlays users hostName;};
in
  lib.nixosSystem {
    inherit system specialArgs;
    modules =
      [
        nixosModules.fuyuNoKosei
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
