_: {
  config,
  lib,
  ...
}: let
  cfg = config.frostbite.security.audit;
  secOpts = config.frostbite.security.settings;
  isOpen = lib.mkIf secOpts.level == "open";
in {
  options = {
    frostbite.security.audit = lib.mkOption {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.dconf.enable = lib.mkForce true;
    security = {
      audit = {
        enable = !isOpen true;
      };
      auditd = {
        enable = !isOpen true;
      };
    };
  };
}
