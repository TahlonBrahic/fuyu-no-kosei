{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.fuyuNoKosei.gaming;
in {
  options = {
    fuyuNoKosei.gaming = {
      enable = lib.mkEnableOption "gaming";
      enableZenKernel = lib.mkOption {
        type = lib.types.bool;
        default = cfg.enable;
      };
    };
  };
  config = lib.mkIf cfg.enable {
    # Built using the best configuration and kernel sources for desktop, multimedia, and gaming workloads.
    boot = lib.mkIf cfg.enableZenKernel {
      extraModulePackages = with config.boot.kernelPackages; [xone];
      kernelPackages = lib.mkForce pkgs.linuxPackages_zen;
    };

    programs = {
      gamemode = {
        enable = true;
        settings = {
          general = {
            softrealtime = "auto";
            renice = 15;
          };
          gpu = {
            apply_gpu_optimizations = "accept-responsibility";
            gpu_device = 0;
          };
        };
      };
      steam = {
        enable = true;

        package = pkgs.steam.override {
          extraPkgs = pkgs:
            with pkgs; [
              keyutils
              libkrb5
              libpng
              libpulseaudio
              libvorbis
              stdenv.cc.cc.lib
              xorg.libXcursor
              xorg.libXi
              xorg.libXinerama
              xorg.libXScrnSaver
            ];
        };
      };
    };
    environment.systemPackages = with pkgs; [
      steamcmd
      steam-tui
      steam-run
      steamtinkerlaunch
      steam-rom-manager
      lutris
      heroic
      bottles
      protonup
      protonplus
      protontricks
      #emulationstation-de
      #pcsx2
      #duckstation
      #xemu
      #dolphin-emu
      #retroarch
      lact
      vesktop
      corectrl
    ];

    # GPU Monitoring and Fan Adjustment
    systemd.packages = with pkgs; [lact];
    systemd.services.lactd.wantedBy = ["multi-user.target"];
  };
}
