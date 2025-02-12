scoped: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.kosei.firewall;
in {
  options = {
    kosei.firewall = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
      level = lib.mkOption {
        type = lib.types.ints.between 0 5;
        default = 2;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    networking = {
      firewall = {
        enable = true;
        allowPing = (lib.mkIf (cfg.level < 4)) true;
        allowedTCPPorts = lib.lists.concatLists [
          [80 443]
        ];
        allowedUDPPorts =
          lib.lists.concatLists [
          ];
      };
    };
    services = {
      openssh.openFirewall = lib.mkIf config.kosei.ssh.enable true;
    };
  };
}
