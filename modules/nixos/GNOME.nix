{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.GNOME;
in {
  options = {
    GNOME = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
      };
      gamemode = {
        startscript = lib.mkOption {
          type = lib.types.string;
          default = "exit 0";
        };
        endscript = lib.mkOption {
          type = lib.types.string;
          default = "exit 0";
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.xserver = {
      enable = true;
      desktopManager.gnome = {
        enable = true;
        debug = true;
      };
    };

    programs.dconf.enable = true;

    environment.gnome.excludePackages = with pkgs; [
      gnome-photos
      gnome-tour
      gnome-terminal
      gnome-music
      xterm
      cheese
      gedit
      epiphany
      geary
      evince
      gnome-characters
      totem
      tali
      iagno
      hitori
      atomix
    ];
  };
}
