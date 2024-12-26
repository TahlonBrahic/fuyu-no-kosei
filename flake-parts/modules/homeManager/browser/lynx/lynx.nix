{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.fuyuNoKosei.browser.lynx;
in {
  options = {
    fuyuNoKosei.browser = {
      lynx.enable = lib.mkOption {
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
