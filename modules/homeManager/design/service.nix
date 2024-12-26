{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  cfg = config.fuyuNoKosei.design;
in {
  imports = [
    inputs.base16.homeManagerModule
  ];

  options = {
    fuyuNoKosei.design = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services.theme-switcher = {
      Unit = {
        Description = "Switches themes for stylix.";
      };

      Service = {
        stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
      };
    };
  };
}
