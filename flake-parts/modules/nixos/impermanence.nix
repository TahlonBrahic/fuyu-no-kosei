{
  config,
  inputs,
  lib,
  ...
}: let
  cfg = config.fuyuNoKosei.impermanence;
in {
  imports = [inputs.impermanence.nixosModules.impermanence];

  options = {
    fuyuNoKosei.impermanence.enable = lib.mkEnableOption "impermanence";
  };

  config = lib.mkIf cfg.enable {
    environment.persistence = {
      "/nix" = {
        enable = true;
        directories = [
          "/nix/store"
          "/nix/var"
        ];
      };
      "/home" = {
        enable = true;
        directories = [
          "test"
        ];
      };
    };
  };
}
