_: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frostbite.environment.locale;
in {
  options = {
    frostbite.environment.locale = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    time.timeZone = "America/New_York";
    i18n = {
      defaultLocale = "en_US.UTF-8";
      supportedLocales = ["ja_JP.UTF-8" "zh_CN.UTF-8" "zh_TW.UTF-8" "all"];
      inputMethod = {
        type = "ibus";
        ibus.engines = with pkgs.ibus-engines; [mozc pinyin uniemoji];
      };
    };
    console.keyMap = "us";
  };
}
