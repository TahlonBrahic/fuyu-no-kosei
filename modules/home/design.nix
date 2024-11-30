{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  cfg = config.fuyuNoKosei.design;
in {
  imports = [
    inputs.base16.homeManagerModule
  ];

  options = {
    fuyuNoKosei.design = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  # TODO: Make this a service to dynamically switch themes
  config = lib.mkIf cfg.enable {
    stylix = {
      enable = true;

      base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";

      cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
      };

      fonts = {
        monospace = {
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetBrainsMono Nerd Font Mono";
        };
        sansSerif = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Sans";
        };
        serif = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Serif";
        };
      };

      opacity = {
        applications = .4;
        popups = .4;
        terminal = .4;
      };

      polarity = "dark";

      targets = {
        rofi.enable = true;
        nixvim.enable = true;
        gnome.enable = false;
        fish.enable = false;
      };
    };
  };
}
