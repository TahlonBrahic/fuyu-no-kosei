{
  config,
  lib,
  ...
}: let
  cfg = config.fuyuNoKosei.laptopSupport;
in {
  options = {
    fuyuNoKosei.laptopSupport = {
      enable = lib.mkEnableOption "laptop suppport";
      enableHyprlandSupport = lib.mkEnableOption "laptop Hyprland support";
    };
  };

  config = lib.mkIf cfg.enable {
    services.logind = {
      lidSwitch = "suspend";
      lidSwitchDocked = "ignore";
      lidSwitchExternalPower = "ignore";
      powerKey = "hibernate";
      powerKeyLongPress = "poweroff";
    };

    hardware.sensor.iio.enable = true;

    programs.iio-hyprland.enable = lib.mkIf cfg.enableHyprlandSupport true;
  };
}
