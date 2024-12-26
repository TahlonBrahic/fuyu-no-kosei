{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.fuyuNoKosei.audio;
in {
  options.fuyuNoKosei.audio.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable sound support";
  };

  config = lib.mkIf cfg.enable {
    services.pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };

      jack.enable = true;
    };

    environment.systemPackages = with pkgs; [
      alsa-utils
      alsa-ucm-conf
    ];

    security.rtkit.enable = true;
  };
}
