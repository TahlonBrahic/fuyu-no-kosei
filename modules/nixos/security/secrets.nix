scoped: {
  config,
  inputs,
  lib,
  pkgs,
  outPath,
  users,
  ...
}: let
  cfg = config.kosei.secrets;
in {
  imports = [inputs.sops-nix.nixosModules.sops];

  options = {
    kosei.secrets = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
      defaultSopsFile = lib.mkOption {
        type = lib.types.path;
        default = "${outPath}/src/secrets/secrets.yaml";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment = {
      persistence = lib.mkIf config.kosei.impermanence.enable {
        "/nix/persistent/".directories = ["/var/lib/sops-nix"];
      };

      systemPackages = with pkgs; [
        age # Simple, secure, modern encryption tool
        sops
      ];

      variables = {
        SOPS_AGE_KEY_FILE = "/var/lib/sops-nix/key.txt";
      };
    };

    sops = {
      age = {
        keyFile = "/var/lib/sops-nix/key.txt";
      };
      inherit (cfg) defaultSopsFile;
      defaultSopsFormat = "yaml";
      secrets =
        lib.mergeAttrs
        (lib.attrsets.mergeAttrsList (builtins.attrValues (lib.genAttrs users (user: {
          "${user}/hashedPasswordFile" = {neededForUsers = true;};
        }))))
        (lib.attrsets.optionalAttrs
          (config.kosei.security.level < 4) {"recovery/hashedPasswordFile" = {neededForUsers = true;};});
    };
  };
}
