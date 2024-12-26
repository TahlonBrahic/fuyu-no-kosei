{
  config,
  inputs,
  lib,
  osConfig,
  ...
}: let
  cfg = config.fuyuNoKosei.hyprlock;
in {
  options = {
    fuyuNoKosei.hyprlock = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.hyprlock = {
      enable = true;

      extraConfig = ''
        # BACKGROUND
        background {
          monitor =
          path = ${inputs.walls}/anime/a_drawing_of_a_horse_carriage_on_a_bridge.png"
          blur_passes = 2
          contrast = 0.8916
          brightness = 0.8172
          vibrancy = 0.1696
          vibrancy_darkness = 0.0
        }

        # GENERAL
        general {
          hide_cursor = true
          no_fade_in = false
          grace = 0
          disable_loading_bar = false
          ignore_empty_input = true
          fractional_scaling = 0
        }

        # Time
        label {
          monitor =
          text = cmd[update:1000] echo "$(date +"%k:%M")"
          font_size = 115
          shadow_passes = 3
          position = 0, ${
          if osConfig.fuyuNoKosei.laptopSupport.enable
          then "-25"
          else "-150"
        }
          halign = center
          valign = top
        }

        # Day
        label {
          monitor =
          text = cmd[update:1000] echo "- $(date +"%A, %B %d") -"
          font_size = 18
          shadow_passes = 3
          position = 0, ${
          if osConfig.fuyuNoKosei.laptopSupport.enable
          then "-225"
          else "-350"
        }
          halign = center
          valign = top
        }


        # USER-BOX
        shape {
          monitor =
          size = 300, 50
          rounding = 15
          border_size = 0
          rotate = 0

          position = 0, ${
          if osConfig.fuyuNoKosei.laptopSupport.enable
          then "120"
          else "270"
        }
          halign = center
          valign = bottom
        }

        # USER
        label {
          monitor =
          text =   $USER
          font_size = 15
          position = 0, ${
          if osConfig.fuyuNoKosei.laptopSupport.enable
          then "131"
          else "281"
        }
          halign = center
          valign = bottom
        }

        # INPUT FIELD
        input-field {
          monitor =
          size = 300, 50
          outline_thickness = 0
          rounding = 15
          dots_size = 0.25 # Scale of input-field height, 0.2 - 0.8
          dots_spacing = 0.4 # Scale of dots' absolute size, 0.0 - 1.0
          dots_center = true
          font_size = 14
          fade_on_empty = false
          placeholder_text = <i>Enter Password</span></i>
          hide_input = false
          position = 0, ${
          if osConfig.fuyuNoKosei.laptopSupport.enable
          then "50"
          else "200"
        }
          halign = center
          valign = bottom
        }
      '';
    };
  };
}
