scoped: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.kosei.SELinux;
  secOpts = config.kosei.security.settings;
  isOpen = lib.mkIf secOpts.level == "open";
in {
  options = {
    kosei.security = {
      SELinux = lib.mkOption {
        type = lib.types.submodule {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
          };
        };
      };
    };
  };

  config = lib.mkIf (cfg.enable && !isOpen) {
    boot.kernelParams = ["security=selinux"];
    # compile kernel with SELinux support - but also support for other LSM modules
    boot.kernelPatches = [
      {
        name = "selinux-config";
        patch = null;
        extraConfig = ''
          SECURITY_SELINUX y
          SECURITY_SELINUX_BOOTPARAM n
          SECURITY_SELINUX_DISABLE n
          SECURITY_SELINUX_DEVELOP y
          SECURITY_SELINUX_AVC_STATS y
          SECURITY_SELINUX_CHECKREQPROT_VALUE 0
          DEFAULT_SECURITY_SELINUX n
        '';
      }
    ];
    # policycoreutils is for load_policy, fixfiles, setfiles, setsebool, semodile, and sestatus.
    environment.systemPackages = with pkgs; [policycoreutils];
    # build systemd with SELinux support so it loads policy at boot and supports file labelling
    systemd.package = pkgs.systemd.override {withSelinux = true;};
  };
}
