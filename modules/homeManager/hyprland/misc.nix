{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.fuyuNoKosei.hyprland;
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
      grim # screenshot functionality
      slurp # screenshot functionality
      wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
      wlogout # wayland logout menu
      wlr-randr # wayland output utility
      wlr-which-key # keymap manager
      mako # notification system
      wofi # gtk-based app launcher
      kitty # backup terminal
      rot8 # screen rotation daemon
      wl-kbptr
      wl-screenrec
      wl-mirror
      wineWowPackages.wayland
      clipman
      swappy
      wpa_supplicant_gui
      wev
      playerctl
      pavucontrol
      waypipe

      # Brightness
      brightnessctl
      wl-gammactl
      wluma
    ];

    # These may be moved to seperate modules.
    services = {
      dunst.enable = true;

      gnome-keyring.enable = true;

      hypridle.enable = true;
    };

    home.sessionVariables = {
      XDG_SESSION_TYPE = "wayland";
    };

    systemd.user.services = {
      waypipe-client = {
        Unit.Description = "Runs waypipe on startup to support SSH forwarding";
        Service = {
          ExecStartPre = "${lib.getExe' pkgs.coreutils "mkdir"} %h/.waypipe -p";
          ExecStart = "${lib.getExe pkgs.waypipe} --socket %h/.waypipe/client.sock client";
          ExecStopPost = "${lib.getExe' pkgs.coreutils "rm"} -f %h/.waypipe/client.sock";
        };
        Install.WantedBy = ["graphical-session.target"];
      };
      waypipe-server = {
        Unit.Description = "Runs waypipe on startup to support SSH forwarding";
        Service = {
          Type = "simple";
          ExecStartPre = "${lib.getExe' pkgs.coreutils "mkdir"} %h/.waypipe -p";
          ExecStart = "${lib.getExe pkgs.waypipe} --socket %h/.waypipe/server.sock --title-prefix '[%H] ' --login-shell --display wayland-waypipe server -- ${lib.getExe' pkgs.coreutils "sleep"} infinity";
          ExecStopPost = "${lib.getExe' pkgs.coreutils "rm"} -f %h/.waypipe/server.sock %t/wayland-waypipe";
        };
        Install.WantedBy = ["default.target"];
      };
    };
  };
}
