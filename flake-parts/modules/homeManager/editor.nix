{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.fuyuNoKosei.editor;
in {
  options = {
    fuyuNoKosei.editor = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
      defaultEditor = lib.mkOption {
        type = lib.types.enum [pkgs.fuyuvim pkgs.jeezyivm pkgs.nvchad pkgs.nvim];
        default = pkgs.fuyuvim;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [cfg.defaultEditor];
  };
}
