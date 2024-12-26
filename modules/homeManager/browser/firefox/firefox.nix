{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.fuyuNoKosei.browser.firefox;
in {
  options = {
    fuyuNoKosei.browser = {
      firefox.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;

      profiles = {
        main = {
          id = 0;
          name = "main";
          settings = {
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
            "browser.urlbar.quickactions.enabled" = false;
            "browser.urlbar.quickactions.showPrefs" = false;
            "browser.urlbar.shortcuts.quickactions" = false;
            "browser.urlbar.suggest.quickactions" = false;
            "browser.startup.homepage" = "about:blank";
            # TODO: add if Yubikey module enabled
            # Yubikey
            "security.webauth.u2f" = true;
            "security.webauth.webauthn" = true;
            "security.webauth.webauthn_enable_softtoken" = true;
            "security.webauth.webauthn_enable_usbtoken" = true;
            "distribution.searchplugins.defaultLocale" = "en-US";
          };

          # TODO: Add an option to choose styles?
          userChrome = builtins.readFile ./twilly.css;

          extensions = with pkgs.nur.repos.rycee.firefox-addons; [
            ublock-origin
            simple-tab-groups
            darkreader
          ];

          search = {
            force = true;
            order = [
              "DuckDuckGo"
              "Google"
            ];
          };
        };

        i2pd = {
          # TODO: add a policy to 'use this proxy for HTTPS' 127.0.0.1:4444 and 4447
          id = 2;
          name = "i2pd";
          search = {
            force = true;
            order = [
              "DuckDuckGo"
            ];
          };
        };
      };

      policies = {
        DisableAccounts = true;
        DisableFirefoxAccounts = true;
        DisableFirefoxScreenshots = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DontCheckDefaultBrowser = true;
        HardwareAcceleration = true;
        NoDefaultBookmarks = true;
        OverrideFirstRunPage = true;
        OverridePostUpdatePage = true;
        toolkit.legacyUserProfileCustomizations.stylesheet = true;
      };
    };
  };
}
