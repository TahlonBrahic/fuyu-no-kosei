{
  config,
  lib,
  ...
}: let
  cfg = config.fuyuNoKosei.browser.librewolf;
in {
  options = {
    fuyuNoKosei.browser = {
      librewolf.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.librewolf = {
      enable = true;
    };
  };
}
