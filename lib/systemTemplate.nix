scoped: {
  extraModules ? [],
  hostName ? "nixos",
  inputs ? self.inputs,
  lib ? inputs.nixpkgs.lib,
  pkgs ? import inputs.nixpkgs {inherit system;},
  system ? "x86_64-linux",
  users ? ["nixos"],
  ...
}: let
  inherit (inputs) kosei home-manager;
  extraArgs = {inherit hostName inputs lib pkgs system users;};
in
  lib.nixosSystem {
    inherit system;
    modules =
      [
        home-manager.nixosModules.home-manager
        {
        }
        {
          home-manager = {
            backupFileExtension = "bak";
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = extraArgs;
            # Iterates over a list of users provided in the function call
            users = inputs.nixpkgs.lib.attrsets.genAttrs users (user: {
              imports =
                lib.forEach
                (builtins.attrNames kosei.modules.home)
                (module: builtins.getAttr module kosei.modules.home);
              config.home.username = user;
            });
          };
        }
      ]
      ++ extraModules
      ++ lib.forEach
      (builtins.attrNames kosei.modules.nixos)
      (module: builtins.getAttr module kosei.modules.nixos);
  }
