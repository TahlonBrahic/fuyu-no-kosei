{
  config,
  hostName,
  inputs,
  lib,
  users,
  ...
}: let
  cfg = config.fuyuNoKosei.wsl;
in {
  imports = [inputs.nixos-wsl.nixosModules.wsl];

  options = {
    fuyuNoKosei.wsl = {
      enable = lib.mkEnableOption "WSL";
    };
  };

  config = lib.mkIf cfg.enable {
    wsl = {
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

    fuyuNoKosei.boot.enable = lib.mkForce false;
  };
}
