{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.fuyuNoKosei.hyprland;

  hyprlandGamemodePrograms = lib.makeBinPath [
    config.programs.hyprland.package
    pkgs.coreutils
    pkgs.power-profiles-daemon
  ];
in {
  options = {
    fuyuNoKosei.hyprland = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      gamemode = {
        startscript = lib.mkOption {
          type = lib.types.string;
          default = pkgs.writeShellScript "gamemode-start" ''
            export PATH=$PATH:${hyprlandGamemodePrograms}
            export HYPRLAND_INSTANCE_SIGNATURE=$(ls -1 /tmp/hypr | tail -1)
            hyprctl --batch 'keyword decoration:blur 0 ; keyword animations:enabled 0 ; keyword misc:vfr 0'
            powerprofilesctl set performance
          '';
        };
        endscript = lib.mkOption {
          type = lib.types.string;
          default = pkgs.writeShellScript "gamemode-end" ''
            export PATH=$PATH:${hyprlandGamemodePrograms}
            export HYPRLAND_INSTANCE_SIGNATURE=$(ls -1 /tmp/hypr | tail -1)
            hyprctl --batch 'keyword decoration:blur 1 ; keyword animations:enabled 1 ; keyword misc:vfr 1'
            powerprofilesctl set power-saver
          '';
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;

      exec-once = [
        "hyprpaper"
      ];

      settings = {
        env = [
          "NIXOS_OZONE_WL, 1"
          "MOZ_ENABLE_WAYLAND, 1"
          "MOZ_WEBRENDER, 1"
          "XDG_SESSION_TYPE, wayland"
          "WLR_NO_HARDWARE_CURSORS, 1"
          "WLR_RENDERER_ALLOW_SOFTWARE, 1"
        ];
      };

      systemd = {
        enable = true;
        variables = ["--all"];
      };

      settings = {
        animations = {
          enabled = true;
          bezier = [
            "wind, 0.05, 0.9, 0.1, 1.05"
            "winIn, 0.1, 1.1, 0.1, 1.1"
            "winOut, 0.3, -0.3, 0, 1"
            "liner, 1, 1, 1, 1"
          ];
          animation = [
            "windows, 1, 6, wind, slide"
            "windowsIn, 1, 6, winIn, slide"
            "windowsOut, 1, 5, winOut, slide"
            "windowsMove, 1, 5, wind, slide"
            "border, 1, 1, liner"
            "borderangle, 1, 30, liner, loop"
            "fade, 1, 10, default"
            "workspaces, 1, 5, wind"
            "specialWorkspace, 1, 5, wind, slidevert"
          ];
        };

        bindl = [
        ];

        bindm = [
          "SUPER,mouse:272,movewindow"
          "SUPER,mouse:273,resizewindow"
        ];

        bind = let
          pactl = lib.getExe' pkgs.pulseaudio "pactl";
          workspaces = ["0" "1" "2" "3" "4" "5" "6" "7" "8" "9"];
          directions = rec {
            left = "l";
            right = "r";
            up = "u";
            down = "d";
            h = left;
            l = right;
            k = up;
            j = down;
          };
        in
          [
            "SUPER,t,exec,kitty"
            "SUPER,f,exec,firefox"
            "SUPER,q,killactive"
            "SUPER,a,exec,killall rofi || rofi -show drun"
            "SUPER,s,togglespecialworkspace"
            "SUPER,g,togglegroup"
            "SUPER,w,fullscreen"
            ''SUPER,p,exec,grim -g "$(slurp)" - | wl-copy && wl-paste > ~/pictures/screenshots''
            ",XF86AudioRaiseVolume,exec,${pactl} set-sink-volume @DEFAULT_SINK@ +5%"
            ",XF86AudioLowerVolume,exec,${pactl} set-sink-volume @DEFAULT_SINK@ -5%"
            ",XF86AudioMute,exec,${pactl} set-sink-mute @DEFAULT_SINK@ toggle"
            '',XF86MonBrightnessUp,exec,brightnessctl set 50+''
            '',XF86MonBrightnessDown,exec,brightnessctl set 50-''
          ]
          ++
          # Change workspaces
          (map (n: "SUPER,${n},workspace,name:${n}") workspaces)
          ++
          # Move window to workspace
          (map (n: "SUPERSHIFT,${n},movetoworkspacesilent,name:${n}") workspaces)
          ++
          # Move focus
          (lib.mapAttrsToList (key: direction: "SUPER,${key},movefocus,${direction}") directions)
          ++ (lib.mapAttrsToList (
              key: direction: "SUPERCONTROL,${key},movewindoworgroup,${direction}"
            )
            directions)
          ++
          # Scroll through existing workspaces
          [
            "SUPER,mouse_down,workspace,e+1"
            "SUPER,mouse_up,workspace,e-1"
          ];

        decoration = {
          rounding = 5;
          fullscreen_opacity = 1.0;

          blur = {
            enabled = true;
            size = 4;
            passes = 2;
          };

          shadow = {
            enabled = true;
            offset = "3 3";
            range = 12;
            color = lib.mkForce "0x44000000";
            color_inactive = lib.mkForce "0x66000000";
          };
        };

        general = {
          gaps_in = 6;
          gaps_out = 6;
          border_size = 0;
          resize_on_border = true;
          hover_icon_on_border = true;
        };
        gestures = {
          workspace_swipe = true;
        };

        input = {
          follow_mouse = 1;
          mouse_refocus = false;

          touchpad = {
            natural_scroll = true;
            disable_while_typing = true;
          };
        };

        layerrule = [
          "blur,rofi"
          "ignorezero,rofi"
          "blur,notifications"
        ];
      };
    };

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
      hyprwall # GUI for hyprpaper
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

      hyprpaper.enable = true;

      hypridle.enable = true;
    };

    programs = {
      hyprlock.enable = true;
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
