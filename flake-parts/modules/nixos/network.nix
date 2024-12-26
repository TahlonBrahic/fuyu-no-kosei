{
  config,
  hostName,
  lib,
  pkgs,
  ...
}: let
  cfg = config.fuyuNoKosei.network;
in {
  options = {
    fuyuNoKosei.network = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    networking = {
      inherit hostName;
      firewall = {
        allowPing = true;
      };
      useDHCP = lib.mkDefault true;
      networkmanager.enable = true;
      useNetworkd = false;
    };

    hardware.bluetooth.enable = true;

    programs.openvpn3 = {
      enable = true;
    };

    environment.systemPackages = with pkgs; [
      gnome-control-center
      networkmanagerapplet
    ];

    services = {
      avahi.enable = true;
      blueman.enable = true;
    };
  };
}
