_: {
  config,
  lib,
  ...
}: let
  cfg = config.frostbite.network.networkd.devices.virtualWired;
in {
  options = {
    frostbite.network.networkd.devices.virtualWired = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = config.frostbite.networking.enable;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd = {
      network = {
        networks = {
          "20-wired-static" = {
            matchConfig = {
              Name = "wired_static_vlan";
            };
            networkConfig = {
              DNSSEC = "allow-downgrade";
            };
            linkConfig = {
              # NOTE: Jumbo Frames
              MTUBytes = 9014;
            };
          };

          # Manage by Networkd but can by configured ad-hoc by IWDGTK (IWD)
          "40-wired-dhcp" = {
            matchConfig = {
              Name = "wired_dhcp_vlan";
            };
            networkConfig = {
              DHCP = "ipv4";
              DNSSEC = "allow-downgrade";
            };
            linkConfig.RequiredForOnline = "routable";
          };
        };
      };
    };
  };
}
