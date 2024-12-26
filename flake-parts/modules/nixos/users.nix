{
  config,
  lib,
  pkgs,
  users,
  ...
}: let
  cfg = config.fuyuNoKosei.users;
in {
  options = {
    fuyuNoKosei.users = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    users = {
      mutableUsers = false;
      users =
        lib.genAttrs users
        (user: {
          home = "/home/${user}";
          # TODO: Add option for users to declare account without sops password?
          hashedPasswordFile = config.sops.secrets."${user}/hashedPasswordFile".path;
          isNormalUser = true;
          # TODO: variable shell for multi-user system?
          shell = pkgs.fish;
          extraGroups = [
            "${user}"
            "users"
            "networkmanager"
            "wheel"
            "docker"
            "libvirtd"
          ];
          # TODO: Iterate over secrets file
          # TODO: API / Documentation for this? Could be confusing for other people
          # Technically these don't need to be secret, I just want the only portable thing to be the secrets file
          # openssh.authorizedKeys.keyFiles = [(builtins.readFile config.sops.secrets."${user}/ssh/publicKeys".path)];
        });
    };

    # Recovery Account
    #specialisation.recovery.configuration =
    #  lib.mkIf (!(builtins.all (value: value.minimal) (builtins.attrValues settings)))
    #  {
    #    security.sudo.extraConfig = lib.mkAfter "recovery ALL=(ALL:ALL) NOPASSWD:ALL";
    #    users.extraUsers.recovery = {
    #      name = "recovery";
    #      description = "Recovery Account";
    #      isNormalUser = true;
    #      uid = 1100;
    #      group = "users";
    #      extraGroups = ["wheel"];
    #      useDefaultShell = true;
    #      initialHashedPassword = lib.mkDefault (builtins.readFile (directory + "/default"));
    #    };
    #  };
  };
}
