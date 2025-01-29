scoped: {
  config,
  inputs,
  lib,
  pkgs,
  nixosConfig,
  ...
}: let
  cfg = config.kosei.hyprland;
  gamemode = inputs.kosei.lib.hyprlandGameMode {inherit config lib pkgs;};
  onMonitorAttached = inputs.kosei.lib.onMonitorAttached {inherit lib pkgs;};
  onMonitorDetached = inputs.kosei.lib.onMonitorDetached {inherit lib pkgs;};
in {
  options = {
    kosei.hyprland = {
      enable = lib.mkEnableOption "hyprland";

      gamemode = {
        startscript = lib.mkOption {
          type = lib.types.string;
          default = gamemode "start";
        };
        endscript = lib.mkOption {
          type = lib.types.string;
          default = gamemode "stop";
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;

      plugins = with pkgs.hyprland-plugins; [
        hyprbars
      ];

      systemd = {
        enable = true;
        variables = ["--all"];
      };

      settings = {
        animations = {
          enabled = true;

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

          bezier = [
            "wind, 0.05, 0.9, 0.1, 1.05"
            "winIn, 0.1, 1.1, 0.1, 1.1"
            "winOut, 0.3, -0.3, 0, 1"
            "liner, 1, 1, 1, 1"
          ];
        };

        env = [
          "NIXOS_OZONE_WL, 1"
          "MOZ_ENABLE_WAYLAND, 1"
          "MOZ_WEBRENDER, 1"
          "XDG_SESSION_TYPE, wayland"
          "WLR_NO_HARDWARE_CURSORS, 1"
          "WLR_RENDERER_ALLOW_SOFTWARE, 1"
        ];

        exec-once = ''
          ${(lib.getExe pkgs.hyprland-monitor-attached)}
          ${onMonitorAttached}
          ${onMonitorDetached}
        '';

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

    home = {
      packages = with pkgs; [
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
        hyprland-protocols # wayland protocols extension for hyprland
        hyprland-monitor-attached
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
      ];

      sessionVariables = {
        XDG_SESSION_TYPE = "wayland";
      };
    };

    services = {
      dunst.enable = true;
      gnome-keyring.enable = true;
    };
  };
}
