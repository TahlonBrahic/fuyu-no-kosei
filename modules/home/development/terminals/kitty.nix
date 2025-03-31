_: {
  lib,
  config,
  ...
}: let
  cfg = config.frostbite.terminals.kitty;
in {
  options = {
    frostbite.terminals.kitty = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.kitty = {
      enable = true;
    };
  };
}
