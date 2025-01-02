{
  description = "Nix flakes abstraction layer that supports multiple users, systems, and architectures.";

  outputs = inputs @ {
    flake-parts,
    self,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs self;} (
      {
        withSystem,
        flake-parts-lib,
        ...
      }: {
        systems = ["x86_64-linux"];
        imports = [
          #inputs.flake-parts.flakeModules.flakeModules
          ./flake-parts/options/lib.nix
          ./flake-parts/options/pkgs.nix
        ];
        perSystem = {system, ...}: rec {
          lib = system: import ./lib {inherit inputs system pkgs;}.lib // inputs.nixpkgs.lib;
          pkgs = system:
            import inputs.nixpkgs {
              inherit system;
              inherit (lib.${system}.overlays) overlays;
              config.allowUnfree = true;
            };
        };
        flake = {
          debug = true;
          homeManagerModules.fuyuNoKosei = import ./modules/homeManager;
          nixosModules.fuyuNoKosei = import ./modules/nixos;
        };
      }
    );

  inputs = {
    base16.url = "github:SenchoPens/base16.nix";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    disko.url = "github:nix-community/disko";
    flake-compat.url = "github:edolstra/flake-compat";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-utils.url = "github:numtide/flake-utils";
    fuyu-no-nur.url = "github:TahlonBrahic/fuyu-no-nur";
    fuyuvim.url = "github:TahlonBrahic/fuyu-no-neovim";
    gitignore.url = "github:hercules-ci/gitignore.nix";
    haumea.url = "github:nix-community/haumea/v0.2.2";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    impermanence.url = "github:nix-community/impermanence";
    jeezyvim.url = "github:LGUG2Z/JeezyVim";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixvim.url = "github:nix-community/nixvim";
    nmd.url = "sourcehut:~rycee/nmd";
    nvchad4nix.url = "github:nix-community/nix4nvchad";
    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-on-droid.url = "github:nix-community/nix-on-droid/release-24.05";
    nur.url = "github:nix-community/NUR";
    pre-commit-hooks.url = "github:cachix/git-hooks.nix";
    sops-nix.url = "github:Mic92/sops-nix";
    stylix.url = "github:danth/stylix";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    ixx.url = "github:NuschtOS/ixx/v0.0.6";
    tt-schemes.url = "github:tinted-theming/schemes";
    tt-schemes.flake = false;
    walls.url = "github:dharmx/walls";
    walls.flake = false;
  };
}
