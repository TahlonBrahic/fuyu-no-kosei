{
  config,
  lib,
  ...
}: let
  cfg = config.fuyuNoKosei.ssh;
in {
  options = {
    fuyuNoKosei.ssh = {
      enable = lib.mkEnableOption "ssh";
    };
  };
  config = lib.mkIf cfg.enable {
    services = {
      openssh = {
        enable = true;
        settings = {
          Banner = "冬の国境";
          PermitRootLogin = "no";
          KbdInteractiveAuthentication = false;
          X11Forwarding = true;
          UsePAM = true;
        };
      };
    };
  };
}
