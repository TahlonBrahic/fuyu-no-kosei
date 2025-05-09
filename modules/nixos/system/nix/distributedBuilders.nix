_: {
  config,
  lib,
  ...
}: let
  cfg = config.frostbite.nix.distributedBuilders;
in {
  options = {
    frostbite.nix.distributedBuilders = {
      enable = lib.mkEnableOption "distributed builders";
    };
  };
  # TODO: Flush this out with declartive submodules
  config = lib.mkIf cfg.enable {
    nix = {
      extraOptions = ''
        builders-use-substitutes = true
      '';
      distributedBuilds = true;
      buildMachines."hostname" = {
        inherit (config.nixpkgs) system;
        sshKey = "temp";
        sshUser = "root";
        hostName = "localhost";
        maxJobs = 4;
        speedFactor = 4;
        supportedFeatures = ["benchmark" "big-parallel"];
      };
    };
  };
}
