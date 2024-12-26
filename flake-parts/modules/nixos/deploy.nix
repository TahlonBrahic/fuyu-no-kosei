{
  config,
  inputs,
  lib,
  ...
}: let
  cfg = config.fuyuNoKosei.deploy;
in {
  imports = [inputs.disko.nixosModules.disko];

  options = {
    fuyuNoKosei.deploy = {
      enable = lib.mkEnableOption "disko deployment";
    };
  };

  config = lib.mkIf cfg.enable {
    # This module is used for remote deployment and should be removed after succesfuly deploying a system
    users.users = {
      root = {
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINn/+0ClH1hC2Tqvahb6oLockr99dLKuK1vo53UHtibF tahlon@TAHLON-LAPTOP"
        ];
      };
    };

    services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "yes";
      };
    };
  };
}
