{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.fuyuNoKosei.browser.chromium;
in {
  options = {
    fuyuNoKosei.browser = {
      chromium.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.chromium = {
      enable = true;
      package = pkgs.ungoogled-chromium;
    };
  };
}
