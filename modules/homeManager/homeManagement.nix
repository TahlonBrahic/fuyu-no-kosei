{
  config,
  lib,
  ...
}: let
  cfg = config.fuyuNoKosei.homeManagement;
  dir = "${config.home.homeDirectory}";
in {
  options = {
    fuyuNoKosei.homeManagement = {
      enable = lib.mkOption {
        default = true;
        example = false;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    xdg = {
      userDirs = {
        enable = true;
        createDirectories = true;
        desktop = null;
        download = "${dir}/inbox";
        documents = "${dir}/documents";
        music = null;
        pictures = null;
        publicShare = null;
        templates = null;
        videos = null;
        extraConfig = {
          XDG_PROJECTS_DIR = "${dir}/projects";
          XDG_SYSTEM_DIR = "${dir}/system";
          XDG_MISC_DIR = "${dir}/misc";
        };
      };
    };

    home = {
      homeDirectory = "/home/${config.home.username}";
      stateVersion = "24.11";
    };

    systemd.user.targets.tray = {
      Unit = {
        Description = "Home Manager System Tray";
        Requires = ["graphical-session-pre.target"];
      };
    };

    home.sessionVariables = {
      XDG_RUNTIME_VARIABLES = "/run/user/$UID";
      EDITOR = "nvim";
    };

    programs.home-manager.enable = true;
  };
}
