{
  config,
  lib,
  ...
}: let
  cfg = config.fuyuNoKosei.services;
in {
  options = {
    fuyuNoKosei.services = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
      ssh.enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
      laptop.enable = lib.mkEnableOption "laptop";
      virtualMachine.enable = lib.mkEnableOption "virtual machine";
      yubikey.enable = lib.mkEnableOption "yubikey";
      syncthing.enable = lib.mkOptions {
        type = lib.types.bool;
        default = true;
      };
    };
  };
  config = lib.mkIf cfg.enable {
    services = {
      openssh = lib.mkIf cfg.ssh.enable {
        enable = true;
        settings = {
          banner = "冬の国境";
          PermitRootLogin = "no";
          KbdInteractiveAuthentication = false;
          X11Forwarding = true;
          UsePAM = true;
        };
      };

      logind = lib.mkIf cfg.laptop.enable {
        lidSwitch = "suspend";
        lidSwitchDocked = "ignore";
        lidSwitchExternalPower = "ignore";
        powerKey = "hibernate";
        powerKeyLongPress = "poweroff";
      };
    };

    programs = {
      ssh = lib.mkIf cfg.ssh.enable {
        startAgent = true;
        # Yubi-Key
        extraConfig = lib.mkIf cfg.yubikey.enable ''
          AddKeysToAgent yes
        '';
      };
    };

    hardware.sensor.iio.enable = lib.mkIf cfg.laptop.enable true;

    programs.iio-hyprland.enable = lib.mkIf cfg.laptop.enable true;

    services = {
      qemuGuest.enable = lib.mkIf cfg.virtualMachine.enable true;
      spice-vdagentd.enable = lib.mkIf cfg.virtualMachine.enable true;
      avahi.enable = true;
      syncthing = lib.mkIf cfg.syncthing.enable {
        settings = {
          enable = true;
          openDefaultPorts = true;
          #devices = {
          #  "device1" = {id = "DEVICE-ID-GOES-HERE";};
          #  "device2" = {id = "DEVICE-ID-GOES-HERE";};
          #};
          # folders = {
          #   "Documents" = {
          #    path = "/home/myusername/Documents";
          #    devices = ["device1" "device2"];
          #  };
          #  "Example" = {
          #    path = "/home/myusername/Example";
          #    devices = ["device1"];
          # By default, Syncthing doesn't sync file permissions. This line enables it for this folder.
          #    ignorePerms = false;
          #  };
        };
      };
    };
    systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true"; # Don't create default ~/Sync folder
  };
}
