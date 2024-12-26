{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.fuyuNoKosei.browser.chrome;
in {
  options = {
    fuyuNoKosei.browser = {
      chrome.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.chromium = {
      enable = true;
      package = pkgs.google-chrome;
    };
  };
}
