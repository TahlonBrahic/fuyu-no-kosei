{
  description = "NixOS configuration that supports multiple users, systems, and architectures.";

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [./flake-parts];
    };

  inputs = {
    /*
       ___           ___           ___           ___       ___
      /\  \         /\  \         /\  \         /\__\     /\  \
      \:\  \       /::\  \       /::\  \       /:/  /    /::\  \
       \:\  \     /:/\:\  \     /:/\:\  \     /:/  /    /:/\ \  \
       /::\  \   /:/  \:\  \   /:/  \:\  \   /:/  /    _\:\~\ \  \
      /:/\:\__\ /:/__/ \:\__\ /:/__/ \:\__\ /:/__/    /\ \:\ \ \__\
     /:/  \/__/ \:\  \ /:/  / \:\  \ /:/  / \:\  \    \:\ \:\ \/__/
    /:/  /       \:\  /:/  /   \:\  /:/  /   \:\  \    \:\ \:\__\
    \/__/         \:\/:/  /     \:\/:/  /     \:\  \    \:\/:/  /
                   \::/  /       \::/  /       \:\__\    \::/  /
                    \/__/         \/__/         \/__/     \/__/
    */
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    devshell.url = "github:numtide/devshell";
    haumea = {
      url = "github:nix-community/haumea/v0.2.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    /*
         ___                       ___           ___
        /\__\          ___        /\  \         /\  \
       /::|  |        /\  \      /::\  \       /::\  \
      /:|:|  |        \:\  \    /:/\ \  \     /:/\:\  \
     /:/|:|__|__      /::\__\  _\:\~\ \  \   /:/  \:\  \
    /:/ |::::\__\  __/:/\/__/ /\ \:\ \ \__\ /:/__/ \:\__\
    \/__/~~/:/  / /\/:/  /    \:\ \:\ \/__/ \:\  \  \/__/
          /:/  /  \::/__/      \:\ \:\__\    \:\  \
         /:/  /    \:\__\       \:\/:/  /     \:\  \
        /:/  /      \/__/        \::/  /       \:\__\
        \/__/                     \/__/         \/__/
    */
    # Editor
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvchad4nix = {
      url = "github:nix-community/nix4nvchad";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    jeezyvim = {
      url = "github:LGUG2Z/JeezyVim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fuyuvim = {
      url = "github:TahlonBrahic/fuyu-no-neovim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Themeing
    base16 = {
      url = "github:SenchoPens/base16.nix";
    };
    tt-schemes = {
      url = "github:tinted-theming/schemes";
      flake = false;
    };
  };
}
