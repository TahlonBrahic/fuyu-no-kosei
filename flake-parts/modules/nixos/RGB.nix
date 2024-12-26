{
  config,
  lib,
  ...
}: let
  cfg = config.fuyuNoKosei.RGB;
in {
  options = {
    fuyuNoKosei.RGB = {
      enable = lib.mkEnableOption "rgb";
    };
  };

  config = lib.mkIf cfg.enable {
    containers.openrgb = {
      autostart = true;
      config = {...}: {
        services.hardware.openrgb = {
          enable = true;
          server.port = 6742;
        };
      };
    };
  };
}
