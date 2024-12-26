{
  pkgs ? let
    lock = (builtins.fromJSON (builtins.readFile ./flake.nix)).nodes.nixpkgs.locked;
    nixpkgs = fetchTarball {
      url = "https://github.com//nixos/nixpkgs/arhive/${lock.rev}.tar.gz";
      sha256 = lock.narHash;
    };
  in
    import nixpkgs,
  ...
}: {
  default = pkgs.mkShell {
    NIX_CONFIG = "extra-experimental-features = nix-command flakes";
    nativeBuildInputs = with pkgs; [
      # Nix
      nix
      home-manager

      git
      # Formatters & Linters
      bashInteractive
      alejandra
      deadnix
      statix
      typos
      nodePackages.prettier

      # Secrets Management
      sops
      age
    ];
  };
}
