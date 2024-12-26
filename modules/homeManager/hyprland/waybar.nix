{
  config,
  lib,
  pkgs,
  ...
}: let
  writeCustomShellApplication = {
    name ? "customScript",
    script, # script
    dependencies ? [],
  }:
    lib.getExe (pkgs.writeShellApplication {
      inherit name;
      text = script;
      runtimeInputs = with pkgs; [coreutils gnugrep systemd] ++ dependencies;
    });
  writeCustomWaybarModule = {
    dependencies ? [],
    script ? "",
    text ? "",
    tooltip ? "",
    alt ? "",
    class ? "",
    percentage ? "",
  }: {
    name = "customWaybarModule";
    dependencies = [pkgs.jq] ++ dependencies;
    script = ''
      ${script}
      jq -cn \
        --arg text "${text}" \
        --arg tooltip "${tooltip}" \
        --arg alt "${alt}" \
        --arg class "${class}" \
        --arg percentage "${percentage}" \
        '{text:$text,tooltip:$tooltip,alt:$alt,class:$class,percentage:$percentage}'
    '';
  };
  cfg = config.fuyuNoKosei.waybar;
in {
  options = {
    fuyuNoKosei.waybar = {
      enable = lib.mkEnableOption "waybar";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      systemd.enable = true;

      package = pkgs.waybar.overrideAttrs (oa: {
        mesonFlags = (oa.mesonFlags or []) ++ ["-Dexperimental=true"];
      });

      settings = {
        mainbar = {
          height = 40;
          margin = "6";
          position = "top";
          font-family = "JetBrainsMono Nerd Font Mono";

          modules-left =
            [
              "hyprland/workspaces"
              "hyprland/submap"
            ]
            ++ [
              "custom/currentplayer"
              "custom/player"
            ];

          modules-center = [
            "cpu"
            "clock"
            "memory"
          ];

          modules-right = [
            "tray"
            "network"
            "pulseaudio"
            "battery"
            "custom/hostname"
          ];

          clock = {
            interval = 1;
            format = "{:%H:%M:%S}";
            format-alt = "{:%Y-%m-%d %H:%M:%S}";
            on-click-left = "mode";
            tooltip-format = ''
              <big>{:%Y %B}</big>
              <tt><small>{calendar}</small></tt>'';
          };
          "hyprland/workspaces" = {
            active-only = false;
            disable-scroll = true;
            format = "{icon}";
            on-click = "activate";
            format-icons = {
              "1" = "I";
              "2" = "II";
              "3" = "III";
              "4" = "IV";
              "5" = "V";
              "6" = "VI";
              "7" = "VII";
              "8" = "VIII";
              "9" = "IX";
              "10" = "X";
              sort-by-number = true;
            };
            persistent-workspaces = {
              "1" = [];
              "2" = [];
              "3" = [];
            };
          };

          cpu = {
            format = "  {usage}%";
          };

          memory = {
            format = "  {}%";
            interval = 5;
          };

          pulseaudio = {
            format-source = "󰍬 {volume}%";
            format-source-muted = "󰍭 0%";
            format = "{icon} {volume}% {format_source}";
            format-muted = "󰸈 0% {format_source}";
            format-icons = {
              default = [
                "󰕿"
                "󰖀"
                "󰕾"
              ];
            };
            on-click = lib.getExe pkgs.pavucontrol;
            on-click-right = writeCustomShellApplication {
              script = "pkill pavucontrol";
            };
          };

          idle_inhibitor = {
            format = "{icon}";
            format-icons = {
              activated = "󰒳";
              deactivated = "󰒲";
            };
          };

          battery = {
            interval = 10;
            format-icons = [
              "󰁺"
              "󰁻"
              "󰁼"
              "󰁽"
              "󰁾"
              "󰁿"
              "󰂀"
              "󰂁"
              "󰂂"
              "󰁹"
            ];
            format = "{icon} {capacity}%";
            format-charging = "󰂄 {capacity}%";
            onclick = "";
          };

          "sway/window" = {
            max-length = 20;
          };

          network = {
            interval = 3;
            format-wifi = "   {essid}";
            format-ethernet = "󰈁 Connected";
            format-disconnected = "";
            tooltip-format = ''
              {ifname}
              {ipaddr}/{cidr}
              Up: {bandwidthUpBits}
              Down: {bandwidthDownBits}'';
          };

          "custom/menu" = {
            interval = 1;
            return-type = "json";
            exec = writeCustomWaybarModule {
              dependencies = [pkgs.hyprland];
              text = "";
              tooltip = ''$(grep PRETTY_NAME /etc/os-release | cut -d '"' -f2)'';
              class = let
                isFullScreen = "hyprctl activewindow -j | jq -e '.fullscreen' &>/dev/null";
              in "$(if ${isFullScreen}; then echo fullscreen; fi)";
            };
          };

          "custom/currentplayer" = {
            interval = 2;
            return-type = "json";
            exec = writeCustomWaybarModule {
              dependencies = [pkgs.playerctl];
              script = ''
                all_players=$(playerctl -l 2>/dev/null)
                selected_player="$(playerctl status -f "{{playerName}}" 2>/dev/null || true)"
                clean_player="$(echo "$selected_player" | cut -d '.' -f1)"
              '';
              alt = "$clean_player";
              tooltip = "$all_players";
            };
            format = "{icon}{}";
            format-icons = {
              "librewolf" = " ";
              "spotify" = "󰓇 ";
              "discord" = " 󰙯 ";
              "kdeconnect" = "󰄡 ";
              "steam" = " ";
            };
          };

          "custom/player" = {
            exec-if = writeCustomShellApplication {
              dependencies = [pkgs.playerctl];
              script = ''
                selected_player="$(playerctl status -f "{{playerName}}" 2>/dev/null || true)"
                playerctl status -p "$selected_player" 2>/dev/null
              '';
            };
            exec = writeCustomShellApplication {
              dependencies = [pkgs.playerctl];
              script = ''
                selected_player="$(playerctl status -f "{{playerName}}" 2>/dev/null || true)"
                playerctl metadata -p "$selected_player" \
                  --format '{"text": "{{artist}} - {{title}}", "alt": "{{status}}", "tooltip": "{{artist}} - {{title}} ({{album}})"}' 2>/dev/null
              '';
            };
            return-type = "json";
            interval = 2;
            max-length = 30;
            format = "{icon} {}";
            format-icons = {
              "Playing" = "󰐊";
              "Paused" = "󰏤 ";
              "Stopped" = "󰓛";
            };
            on-click = writeCustomShellApplication {
              dependencies = [pkgs.playerctl];
              script = "playerctl play-pause";
            };
          };

          "custom/hostname" = {
            exec = writeCustomShellApplication {
              script = ''
                echo "$USER@$HOSTNAME"
              '';
            };
          };
        };
      };
      style = ''
        * {
          font-size: 12pt;
          padding: 0;
          margin: 0 0.4em;
        }

        window#waybar {
          padding: 0;
          border-radius: 0.5em;
        }
        .modules-left {
          margin-left: -0.65em;
        }
        .modules-right {
          margin-right: -0.65em;
        }

        #workspaces button {
          padding-left: 0.4em;
          padding-right: 0.4em;
          margin-top: 0.15em;
          margin-bottom: 0.15em;
        }
        #clock {
          padding-right: 1em;
          padding-left: 1em;
          border-radius: 0.5em;
        }

        #custom-menu {
          padding-right: 1.5em;
          padding-left: 1em;
          margin-right: 0;
          border-radius: 0.5em;
        }
        #custom-hostname {
          padding-right: 1em;
          padding-left: 1em;
          margin-left: 0;
          border-radius: 0.5em;
        }
        #custom-currentplayer {
          padding-right: 0;
        }
        #cpu, #memory {
          margin-left: 0.05em;
          margin-right: 0.55em;
        }
      '';
    };
  };
}
