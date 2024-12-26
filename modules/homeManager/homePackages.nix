{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.fuyuNoKosei.homePackages;
in {
  options = {
    fuyuNoKosei.homePackages = {
      enable = lib.mkEnableOption "fuyuNoKosei home packages";
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # Proton
      protonvpn-gui
      protonmail-desktop

      # Music
      musescore
      audacity

      # Visual
      cheese
      aseprite
      inkscape
      blender
      gimp-with-plugins
    ];

    programs = {
      obs-studio = {
        enable = true;
        plugins = with pkgs.obs-studio-plugins; [
          wlrobs
          obs-vaapi
          obs-nvfbc
          obs-teleport
          obs-vkcapture
          obs-gstreamer
          obs-3d-effect
          input-overlay
          obs-multi-rtmp
          obs-source-clone
          obs-shaderfilter
          obs-source-record
          obs-livesplit-one
          looking-glass-obs
          obs-command-source
          obs-move-transition
          obs-backgroundremoval
          obs-pipewire-audio-capture
        ];
      };
    };
  };
}
