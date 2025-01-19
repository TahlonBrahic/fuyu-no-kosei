scoped: {
  config,
  inputs,
  lib,
  ...
}: let
  cfg = config.kosei.design;
in {
  options = {
    kosei.design = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
      wallpaper = lib.mkOption {
        type = lib.types.path;
        default = "${config.home.homeDirectory}/.local/state/wpaperd/wallpapers";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.wpaperd = lib.mkForce {
      enable = true;
      settings = {
        default = {
          path = cfg.wallpaper;
        };
      };
    };

    stylix = {
      enable = true;
      autoEnable = true;

      image = "${cfg.wallpaper}";

      targets = {
        bat.enable = true;
        btop.enable = true;
        firefox.enable = true;
        fzf.enable = true;
        gtk.enable = true;
        hyprland.enable = true;
        hyprlock.enable = true;
        hyprpaper.enable = true;
        kitty.enable = true;
        librewolf.enable = true;
        mangohud.enable = true;
        rofi.enable = true;
        waybar.enable = true;
        zellij.enable = true;
      };
    };
  };
}
