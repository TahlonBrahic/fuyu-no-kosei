{
  self,
  inputs,
  ...
}: let
  projectRoot = self.outPath;
in {
  imports = [
    inputs.devshell.flakeModule
    inputs.hercules-ci-effects.flakeModule
    inputs.git-hooks-nix.flakeModule
  ];

  perSystem = {
    config,
    pkgs,
    ...
  }: {
    devshells.default = {
      name = "Kosei Development Shell";
      devshell.prj_root_fallback = {
        # Use the top-level directory of the working tree
        eval = "$(git rev-parse --show-toplevel)";
      };

      motd = ''
        ${config.pre-commit.installationScript}
           {117}❄ Kosei Developement Shell ❄{reset}
           $(type -p menu &>/dev/null && menu)
      '';
      env = [
        {
          name = "IN_KOSEI_SHELL";
          value = 0;
        }
        {
          name = "NIX_CONFIG";
          value = "experimental-features = nix-command flakes pipe-operators";
        }
      ];
      commands = [
        {
          name = "repl";
          category = "flake";
          command = ''
            nix repl --expr "builtins.getFlake \"$PWD\""
          '';
          help = "Enter this flake's REPL";
        }
        {
          name = "repair store";
          category = "flake";
          command = ''
            nix-collect-garbage -d && sudo nix-store --verify --check-contents --repair
          '';
          help = "Clean then repair the nix store";
        }
      ];
      packages = [
        pkgs.typos
      ];
    };

    pre-commit = {
      check.enable = true;

      settings = {
        addGcRoot = true;

        excludes = [
          "${projectRoot}/.direnv"
          "${projectRoot}/.git"
          "${projectRoot}/.local"
        ];

        hooks = {
          alejandra = {
            enable = true;
          };

          detect-aws-credentials = {
            enable = true;
          };

          detect-private-keys = {
            enable = true;
          };

          ripsecrets = {
            enable = true;
          };

          sort-file-contents = {
            enable = true;
          };

          treefmt = {
            enable = true;
            settings = {
              no-cache = true;
              fail-on-change = true;
              formatters = [
                pkgs.alejandra
                pkgs.shfmt
              ];
            };
          };

          typos = {
            enable = true;
            settings = {
              binary = false;
              exclude = "*.nix";
              diff = true;
              hidden = false;
              ignored-words = ["kosei" "Kosei"];
              no-check-filenames = true;
            };
          };
        };
      };
    };

    hercules-ci = {
      # Automatically updates flake inputs
      flake-update = {
        when = {
          hour = [2];
          dayOfMonth = builtins.genList (x: x) 31;
        };

        # This requires GitHub branch protection to be configured for the repository.
        autoMergeMethod = true;
        baseMerge.enable = true;
        createPullRequest = true;
        github-pages.branch = null; # Github pages deployment is maintained through Github CI

        flakes = {
          "." = {};
          "./modules/flake/partitions/dev/" = {};
        };
      };
    };
  };
}
