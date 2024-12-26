{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.fuyuNoKosei.torrenting;
  systemStateVersion = config.system.stateVersion;
in {
  options = {
    fuyuNoKosei.torrenting = {
      enable = lib.mkEnableOption "torrenting";
    };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      bitmagnet
      xd
    ];

    containers = {
      deluge-container = {
        autoStart = true;
        config = {...}: {
          services.deluge = {
            enable = true;
            declarative = true;
            authFile = config.sops.secrets.deluge-accounts.path;
            config = {
              copy_torrent_file = true;
              move_completed = true;
              torrentfiles_location = "/srv/torrents/files";
              download_location = "/srv/torrents/downloading";
              move_completed_path = "/srv/torrents/completed";
              dont_count_slow_torrents = true;
              max_active_seeding = -1;
              max_active_limit = -1;
              max_active_downloading = 8;
              max_connections_global = -1;
              # Daemon on 58846
              allow_remote = true;
              daemon_port = 58846;
              # Listen on 6880 only
              random_port = false;
              listen_ports = [
                6880
                6880
              ];
              # Outgoing is random
              random_outgoing_ports = true;
            };
            openFirewall = true; # Forward listen ports
          };

          sops.secrets.deluge-accounts = {
            sopsFile = ../secrets.yaml;
            owner = config.users.users.deluge.name;
            group = config.users.users.deluge.group;
            mode = "0600";
          };

          networking.firewall = {
            # Remote control port
            allowedTCPPorts = [58846];
            # Listen
            allowedTCPPortRanges = [
              {
                from = 6880;
                to = 6890;
              }
            ];
          };

          system.stateVersion = systemStateVersion;
        };
      };
      i2pd-container = {
        autoStart = true;
        config = {...}: {
          networking.firewall.allowedTCPPorts = [
            7656 # SAM
            7070 # Web Interface
            4447 # SOCKS Proxy
            4444 # HTTP Proxy
          ];

          services.i2pd = {
            enable = true;
            address = "127.0.0.1";
            proto = {
              http.enable = true;
              socksProxy.enable = true;
              httpProxy.enable = true;
              sam.enable = true;
            };
          };

          system.stateVersion = systemStateVersion;
        };
      };
    };
  };
}
