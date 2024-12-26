{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.fuyuNoKosei.developmentTools;
in {
  options = {
    fuyuNoKosei.developmentTools.enable = lib.mkOption {
      default = true;
      example = false;
      description = "Whether to enable the custom fuyu development environment.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      gh
      just
      rustup
      cargo-cache
      cargo-expand
      mkcert
      httpie
      ansible
      tree-sitter
      any-nix-shell

      # Language Servers
      nil

      # Formatters and Linters
      alejandra
      deadnix
      nodePackages.prettier
      shellcheck
      shfmt
      statix

      # Encryption
      age
      # TODO: Add option
      # age-plugin-yubikey
      sops
      rclone

      # Archival
      gzip
      zip
      zstd

      # Android
      adb-sync
      adbfs-rootless
      scrcpy # Display and control Android devices over USB or TCP/IP
    ];

    programs = {
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
      broot = {
        enable = true;
        enableBashIntegration = true;
        enableFishIntegration = true;
        enableZshIntegration = true;
      };
      fzf = {
        enable = true;
        enableBashIntegration = true;
        enableFishIntegration = true;
        enableZshIntegration = true;
      };
      git = {
        enable = true;
        lfs.enable = true;
        delta.enable = true;
        delta.options = {
          line-numbers = true;
          side-by-side = true;
          navigate = true;
        };

        userName = "TahlonBrahic";
        userEmail = "tahlonbrahic@gmail.com";

        extraConfig = {
          init.defaultBranch = "main";

          push = {
            default = "current";
            autoSetupRemote = true;
          };

          pull = {
            rebase = true;
          };

          merge = {
            conflictstyle = "diff3";
          };

          diff = {
            colorMoved = "default";
          };

          url = {
            "ssh://git@github.com/TahlonBrahic" = {
              insteadOf = "https://github.com/TahlonBrahic";
            };
          };
        };
      };

      lsd = {
        enable = true;
        enableAliases = true;
      };

      starship = {
        enable = false;
        enableFishIntegration = true;
        settings = {
          aws.disabled = true;
          gcloud.disabled = true;
          kubernetes.disabled = false;
          git_branch.style = "242";
          directory = {
            style = "blue";
            truncate_to_repo = false;
            truncation_length = 8;
          };
          python.disabled = true;
          ruby.disabled = true;
          hostname.ssh_only = false;
          hostname.style = "bold green";
        };
      };

      zoxide = {
        enable = true;
        enableFishIntegration = true;
        options = ["--cmd cd"];
      };
    };
  };
}
