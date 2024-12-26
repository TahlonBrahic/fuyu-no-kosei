{
  config,
  lib,
  ...
}: let
  cfg = config.fuyuNoKosei.qemuGuest;
in {
  options = {
    fuyuNoKosei.qemuGuest = {
      enable = lib.mkEnableOption "QEMU guest suppport";
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      qemuGuest.enable = true;
      spice-vdagentd.enable = true;
    };
  };
}
