{
  lib,
  config,
  inputs,
  pkgs,
  ...
}: let
  cfg = config.fuyuNoKosei.hyprland;
  wallpapers = inputs.walls.outPath;
in {
  options = {
    fuyuNoKosei.hyprland = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      hyprwall # GUI for hyprpaper
    ];

    xdg.configFile."hyprwall/config.ini".text = ''
      [Settings]
      folder = ${wallpapers}
      backend = hyprpaper
      last_wallpaper = none
    '';

    services = {
      hyprpaper.enable = true;
    };
  };
}
