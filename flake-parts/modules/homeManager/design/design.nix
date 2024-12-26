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

      cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
      };

      fonts = {
        monospace = {
          package = pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];};
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
        applications = .1;
        popups = .1;
        terminal = .1;
      };

      polarity = "dark";

      targets = {
        nixvim = {
          enable = true;
          plugin = "base16-nvim";
        };
        gnome.enable = false;
        fish.enable = false;
      };
    };
  };
}
