_: {
  config,
  lib,
  ...
}: let
  cfg = config.frostbite.environment;
in {
  options = {
    frostbite.environment = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.variables = {
      EDITOR = "nvim";
      PAGER = "bat";
      LANG = "en_US.UTF-8";
      LC_ALL = "en_US.UTF-8"; # Fallback to English
    };
    environment.enableAllTerminfo = true;
  };
}
