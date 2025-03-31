_: {
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frostbite.browser.lynx;
in {
  options = {
    frostbite.browser.lynx = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.w3m
      pkgs.lynx
    ];
  };
}
