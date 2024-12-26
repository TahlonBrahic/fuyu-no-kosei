{
  config,
  hostName,
  inputs,
  lib,
  pkgs,
  users,
  ...
}: let
  cfg = config.fuyuNoKosei.virtualization;
in {
  imports = [inputs.nixos-wsl.nixosModules.wsl];

  options = {
    fuyuNoKosei.virtualization = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
      wsl = {
        enable = lib.mkEnableOption "WSL Integration";
      };
      waydroid.enable = lib.mkEnableOption "waydroid";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation = {
      docker = {
        enable = true;
        daemon.settings = {
          "features" = {"containerd-snapshotter" = true;};
        };

        enableOnBoot = true;
        autoPrune.enable = true;
      };

      libvirtd = {
        enable = true;
        qemu.runAsRoot = true;
      };
      lxd.enable = true;
    };

    environment.systemPackages = with pkgs; [
      virt-manager
      qemu_kvm
      qemu
    ];

    wsl = lib.mkIf cfg.wsl.enable {
      enable = true;
      defaultUser = builtins.elemAt users 0;
      startMenuLaunchers = true;

      wslConf = {
        automount.root = "/mnt";
        interop.appendWindowsPath = false;
        network.generateHosts = false;
        network.hostname = "${hostName}";
      };
    };

    virtualisation.waydroid.enable = lib.mkIf cfg.waydroid.enable true;

    fuyuNoKosei.boot.enable = (lib.mkIf cfg.wsl.enable) (lib.mkForce false);
  };
}
