scoped: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.kosei.rofi;
in {
  options = {
    kosei.rofi = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = config.kosei.hyprland.enable;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.rofi-wayland-unwrapped];

    xdg.configFile."rofi/config.rasi".text = ''
      configuration{
        modi: "run,drun,window";
        lines: 5;
        cycle: false;
        font: "JetBrainsMono NF Bold 15";
        show-icons: true;
        icon-theme: "Papirus-dark";
        terminal: "kitty";
        drun-display-format: "{icon} {name}";
        location: 0;
        disable-history: true;
        hide-scrollbar: true;
        display-drun: " Apps ";
        display-run: " Run ";
        display-window: " Window ";
        sidebar-mode: true;
        sorting-method: "fzf";
      }
    '';
  };
}
