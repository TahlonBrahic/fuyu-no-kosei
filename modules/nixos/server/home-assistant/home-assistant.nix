_: {
  config,
  lib,
  inputs,
  pkgs,
  system,
  ...
}: let
  cfg = config.frostbite.server.home-assistant;
  systemStateVersion = config.system.stateVersion;
  inherit config inputs pkgs;
in {
  options = {
    frostbite.server.home-assistant = {
      enable = lib.mkEnableOption "home-assistant";

      domain = lib.mkOption {
        type = lib.types.str;
        default = null;
        example = "foobar.org";
      };

      email = lib.mkOption {
        type = lib.types.str;
        default = null;
        example = "foo@bar.org";
      };

      s3bucket = lib.mkOption {
        type = lib.types.str;
        default = null;
        example = "https://s3.us-east-2.amazonaws.com/bucketname";
      };
    };
  };
  config = lib.mkIf cfg.enable {
    environment = {
      systemPackages = with pkgs; [
        home-assistant-cli
      ];
      persistence = lib.mkIf config.frostbite.security.impermanence.enable {
        "/nix/persistent/".directories = ["/var/lib/hass"];
      };
    };

    # TODO: Asserts secrets must be enabled
    containers = {
      home-assistant-container = {
        autoStart = true;
        specialArgs = {inherit inputs;};
        config = {config, ...}: {
          services = {
            home-assistant = {
              enable = true;
              openFirewall = true;
              configDir = "/var/lib/hass";
              # default = config.contents;
              # defaultText = lib.literalExpression "contents";
              # Home Assistant has a monthly release schedule so
              # it is nice to receive those updates as soon as they
              # are released to everyone else.
              package = inputs.nixpkgs-master.legacyPackages.${system}.home-assistant;
              config = {
                homeassistant = {
                  unit_system = "metric";
                  temperature_unit = "C";
                  name = "Home-Server";
                  longitude = null;
                  latitude = null;
                };
              };

              lovelaceConfigWritable = false;
              lovelaceConfig = import ./__lovelace.nix;
              customLovelaceModules = with inputs.nixpkgs-master.legacyPackages.${system}.home-assistant-custom-lovelace-modules; [
                mini-graph-card
                mini-media-player
              ];

              extraComponents = [
                "abode"
                "application_credentials"
                "alert"
                "automation"
                "blueprint"
                "bluetooth"
                "calendar"
                "counter"
                "device_automation"
                "frontend"
                "hardware"
                "logger"
                "network"
                "system_health"
                "automation"
                "person"
                "plex"
                "scene"
                "script"
                "tag"
                "zone"
                "counter"
                "input_boolean"
                "input_button"
                "input_datetime"
                "input_number"
                "input_select"
                "input_text"
                "proximity"
                "schedule"
                "timer"
                "backup"
              ];

              #customComponents = with inputs.nixpkgs-master.legacyPackages.${system}.home-assistant-custom-components; [
              # alarmo
              # mass
              #];

              # Reverse Proxy
              config = {
                http = {
                  server_host = "0.0.0.0";
                  server_port = 8123;
                  trusted_proxies = ["0.0.0.0"];
                  use_x_forwarded_for = true;
                };
              };
            };

            # Reverse Proxy
            nginx = {
              enable = true;
              recommendedProxySettings = true;

              virtualHosts."home.${cfg.domain}" = {
                forceSSL = true;
                enableACME = true; # Enable ACME (certificate generation) with Route 53

                locations."/" = {
                  proxyPass = "http://127.0.0.1:8123";
                  proxyWebsockets = true;
                };

                extraConfig = ''
                  proxy_buffering off;
                '';
              };
            };
          };

          security.acme = {
            acceptTerms = true;

            certs = {
              "home.${cfg.domain}" = {
                inherit (cfg) email fqdn;
                dnsProvider = "route53";
              };
            };

            defaults = {
              inherit (cfg) email;
              server = "https://acme-v02.api.letsencrypt.org/directory";
              environmentFile = "${config.sops.templates."certs.secret".path}";
            };
          };

          environment.systemPackages = with pkgs; [
            lego
          ];

          sops.secrets = {
            hass = {
              "AWS_ACCESS_KEY_ID" = {};
              "AWS_SECRET_ACCESS_KEY" = {};
            };

            templates = {
              "certs.secret" = {
                content = ''
                  AWS_ACCESS_KEY_ID = "${config.sops.placeholder."AWS_ACCESS_KEY_ID"}"
                  AWS_SECRET_ACCESS_KEY = "${config.sops.placeholder."AWS_SECRET_ACCESS_KEY"}"
                '';
                owner = "acme";
              };
            };
          };

          nixpkgs.config.allowUnfree = true;

          system.stateVersion = systemStateVersion;
        };
      };
    };
  };
}
