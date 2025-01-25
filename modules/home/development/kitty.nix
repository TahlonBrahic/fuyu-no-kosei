scoped: {
  lib,
  config,
  ...
}: let
  cfg = config.kosei.kitty;
in {
  options = {
    kosei.kitty.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.kitty = {
      enable = true;
    };
  };
}