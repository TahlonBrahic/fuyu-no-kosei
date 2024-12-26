{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.fuyuNoKosei.yubikey;
in {
  options = {
    fuyuNoKosei.yubikey.enable = lib.mkEnableOption "yubikey";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      pam_u2f
    ];

    services = {
      pcscd.enable = true;
      yubikey-agent.enable = true;
      udev = {
        packages = with pkgs; [yubikey-personalization];
        extraRules = ''
          ACTION=="remove",\
           ENV{ID_BUS}=="usb",\
           ENV{ID_MODEL_ID}=="0407",\
           ENV{ID_VENDOR_ID}=="1050",\
           ENV{ID_VENDOR}=="Yubico",\
           RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
        '';
      };
    };

    security.pam = lib.optionalAttrs pkgs.stdenv.isLinux {
      sshAgentAuth.enable = true;
      u2f = {
        enable = true;
        settings = {
          cue = false;
          authFile = "/etc/secure/Yubico/u2f_keys";
        };
      };
      services = {
        login.u2fAuth = true;
        sudo = {
          u2fAuth = true;
          sshAgentAuth = true;
        };
      };
    };

    programs = {
      ssh = lib.mkIf config.fuyuNoKosei.ssh.enable {
        startAgent = true;
        extraConfig = ''
          AddKeysToAgent yes
        '';
      };
    };
  };
}
