{
  inputs,
  pkgs,
  system,
  lib,
  overlays,
  ...
}: let
  hostName = "yourMachine"; # Replace with your given host name
  users = ["user1" "user2"]; # Replace with list of user(s)
  # All other nix modules are prepended with underscores so they are ignored by Haumea
  extraConfig = [
    ./_home.nix # Define all user configuration files here or split them up per user
    ./_configuration.nix # Define NixOS (system) configurations here
    ./_hardware-configuration.nix # Define your hardware configuration here
    # Any other nix modules to be imported
  ];
in {
  nixosConfigurations = {
    ${hostName} =
      lib.systemTemplate
      {
        inherit inputs pkgs system hostName extraConfig users lib overlays;
      };
  };
}
