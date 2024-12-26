{
  config,
  lib,
  osConfig,
  pkgs,
  user,
  utils,
  ...
}: let
  inherit
    (lib)
    mkOption
    types
    mkDefault
    mkEnableOption
    literalExpression
    ;

  cfg = config.fuyuNoKosei.gnome;
  serviceCfg = osConfig.services.gnome;

  # Prioritize nautilus by default when opening directories
  mimeAppsList = pkgs.writeTextFile {
    name = "gnome-mimeapps";
    destination = "/home/${user}/.local/share/applications/mimeapps.list";
    text = ''
      [Default Applications]
      inode/directory=nautilus.desktop;org.gnome.Nautilus.desktop
    '';
  };

  nixos-gsettings-desktop-schemas = pkgs.gnome.nixos-gsettings-overrides.override {
    inherit (cfg) extraGSettingsOverrides extraGSettingsOverridePackages favoriteAppsOverride;
  };

  notExcluded = pkg: mkDefault (!(lib.elem pkg config.environment.gnome.excludePackages));
in {
  options = {
    gnome = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable GNOME desktop manager.";
      };

      debug = mkEnableOption "pkgs.gnome-session debug messages";
    };

    environment.gnome.excludePackages = mkOption {
      default = [];
      example = literalExpression "[ pkgs.totem ]";
      type = types.listOf types.package;
      description = "Which packages gnome should exclude from the default environment";
    };
  };

  osConfig = lib.mkMerge [
    {
      # Seed our configuration into nixos-generate-config
      system.nixos-generate-config.desktopConfiguration = [
        ''
          # Enable the GNOME Desktop Environment.
          services.xserver.displayManager.gdm.enable = true;
          services.xserver.desktopManager.gnome.enable = true;
        ''
      ];

      services = {
        gnome = {
          core-os-services.enable = true;
          core-shell.enable = true;
          core-utilities.enable = mkDefault true;
        };

        displayManager.sessionPackages = [pkgs.gnome-session.sessions];
      };

      environment = {
        extraInit = ''
          ${lib.concatMapStrings (p: ''
              if [ -d "${p}/share/gsettings-schemas/${p.name}" ]; then
                export XDG_DATA_DIRS=$XDG_DATA_DIRS''${XDG_DATA_DIRS:+:}${p}/share/gsettings-schemas/${p.name}
              fi

              if [ -d "${p}/lib/girepository-1.0" ]; then
                export GI_TYPELIB_PATH=$GI_TYPELIB_PATH''${GI_TYPELIB_PATH:+:}${p}/lib/girepository-1.0
                export LD_LIBRARY_PATH=$LD_LIBRARY_PATH''${LD_LIBRARY_PATH:+:}${p}/lib
              fi
            '')
            cfg.sessionPath}
        '';

        systemPackages = cfg.sessionPath;

        sessionVariables.GNOME_SESSION_DEBUG = lib.mkIf cfg.debug "1";

        # Override GSettings schemas
        sessionVariables.NIX_GSETTINGS_OVERRIDES_DIR = "${nixos-gsettings-desktop-schemas}/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas";
      };
    }

    {
      hardware.bluetooth.enable = mkDefault true;
      programs.dconf.enable = true;
      security.polkit.enable = true;
      services = {
        accounts-daemon.enable = true;
        dleyna-renderer.enable = mkDefault true;
        dleyna-server.enable = mkDefault true;
        power-profiles-daemon.enable = mkDefault true;
        gnome = {
          at-spi2-core.enable = true;
          evolution-data-server.enable = true;
          gnome-keyring.enable = true;
          gnome-online-accounts.enable = mkDefault true;
          localsearch.enable = mkDefault true;
          tinysparql.enable = mkDefault true;
        };
        hardware.bolt.enable = mkDefault true;
        udisks2.enable = true;
        upower.enable = config.powerManagement.enable;
        libinput.enable = mkDefault true;
        xserver.updateDbusEnvironment = true;
      };

      xdg = {
        mime.enable = true;
        icons.enable = true;
        portal = {
          enable = true;
          extraPortals = [
            pkgs.xdg-desktop-portal-gnome
            pkgs.xdg-desktop-portal-gtk
          ];
          configPackages = mkDefault [pkgs.gnome-session];
        };
      };

      networking.networkmanager.enable = mkDefault true;

      home.packages = with pkgs; [
        sound-theme-freedesktop
      ];

      # Needed for themes and backgrounds
      environment.pathsToLink = [
        "/share" # TODO: https://github.com/NixOS/nixpkgs/issues/47173
      ];
    }

    {
      services = {
        xserver.desktopManager.gnome.sessionPath = let
          mandatoryPackages = [
            pkgs.gnome-shell
          ];
          optionalPackages = [
            pkgs.gnome-shell-extensions
          ];
        in
          mandatoryPackages
          ++ utils.removePackagesByName optionalPackages config.environment.gnome.excludePackages;

        colord.enable = mkDefault true;
        gnome = {
          glib-networking.enable = true;
          gnome-browser-connector.enable = mkDefault true;
          gnome-initial-setup.enable = mkDefault true;
          gnome-remote-desktop.enable = mkDefault true;
          gnome-settings-daemon.enable = true;
          gnome.gnome-user-share.enable = mkDefault true;
          rygel.enable = mkDefault true;
        };
        gvfs.enable = true;
        system-config-printer.enable = lib.mkIf config.services.printing.enable (mkDefault true);
        flatpak.enable = true;
      };

      systemd.packages = [
        pkgs.gnome-session
        pkgs.gnome-shell
      ];

      services.udev.packages = [
        # Force enable KMS modifiers for devices that require them.
        # https://gitlab.gnome.org/GNOME/pkgs.mutter/-/merge_requests/1443
        pkgs.mutter
      ];

      services.avahi.enable = mkDefault true;

      services.geoclue2.enable = mkDefault true;
      services.geoclue2.enableDemoAgent = false; # GNOME has its own geoclue agent

      services.geoclue2.appConfig.gnome-datetime-panel = {
        isAllowed = true;
        isSystem = true;
      };
      services.geoclue2.appConfig.gnome-color-panel = {
        isAllowed = true;
        isSystem = true;
      };
      services.geoclue2.appConfig."org.gnome.Shell" = {
        isAllowed = true;
        isSystem = true;
      };

      services.orca.enable = notExcluded pkgs.orca;

      fonts.packages = with pkgs; [
        cantarell-fonts
        dejavu_fonts
        source-code-pro # Default monospace font in 3.32
        source-sans
      ];

      # Adapt from https://gitlab.gnome.org/GNOME/gnome-build-meta/blob/gnome-3-38/elements/core/meta-gnome-core-shell.bst
      home.packages = let
        mandatoryPackages = [
          pkgs.gnome-shell
        ];
        optionalPackages = [
          pkgs.adwaita-icon-theme
          pkgs.gnome-backgrounds
          pkgs.gnome-bluetooth
          pkgs.gnome-color-manager
          pkgs.gnome-control-center
          pkgs.gnome-shell-extensions
          pkgs.gnome-tour # GNOME Shell detects the .desktop file on first log-in.
          pkgs.gnome-user-docs
          pkgs.glib # for gsettings program
          pkgs.gnome-menus
          pkgs.gtk3.out # for gtk-launch program
          pkgs.xdg-user-dirs # Update user dirs as described in https://freedesktop.org/wiki/Software/xdg-user-dirs/
          pkgs.xdg-user-dirs-gtk # Used to create the default bookmarks
        ];
      in
        mandatoryPackages
        ++ utils.removePackagesByName optionalPackages config.environment.gnome.excludePackages;
    }

    (lib.mkIf serviceCfg.core-utilities.enable {
      environment.systemPackages =
        utils.removePackagesByName [
          pkgs.baobab
          pkgs.epiphany
          pkgs.gnome-text-editor
          pkgs.gnome-calculator
          pkgs.gnome-calendar
          pkgs.gnome-characters
          pkgs.gnome-clocks
          pkgs.gnome-console
          pkgs.gnome-contacts
          pkgs.gnome-font-viewer
          pkgs.gnome-logs
          pkgs.gnome-maps
          pkgs.gnome-music
          pkgs.gnome-system-monitor
          pkgs.gnome-weather
          pkgs.loupe
          pkgs.nautilus
          pkgs.gnome-connections
          pkgs.simple-scan
          pkgs.snapshot
          pkgs.totem
          pkgs.gnome-software
        ]
        config.environment.gnome.excludePackages;

      programs.evince.enable = notExcluded pkgs.evince;
      programs.file-roller.enable = notExcluded pkgs.file-roller;
      programs.geary.enable = notExcluded pkgs.geary;
      programs.gnome-disks.enable = notExcluded pkgs.gnome-disk-utility;
      programs.seahorse.enable = notExcluded pkgs.seahorse;
      services.gnome.sushi.enable = notExcluded pkgs.sushi;
      programs.bash.vteIntegration = mkDefault true;
      programs.zsh.vteIntegration = mkDefault true;

      environment = {
        sessionVariables = {
          NAUTILUS_4_EXTENSION_DIR = "${config.system.path}/lib/nautilus/extensions-4";

          # Override default mimeapps for nautilus
          sessionVariables.XDG_DATA_DIRS = ["${mimeAppsList}/share"];
        };

        environment.pathsToLink = [
          "/home/${user}/.local/share/nautilus-python/extensions"
        ];
      };
    })
  ];
}
