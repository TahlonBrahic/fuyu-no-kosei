{
  description = "Documentation for the Fuyu no Kosei module system";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
  };

  outputs = {inputs}:
    inputs.flake-utils.lib.eachDefaultSystem (
      system: let
        inherit (inputs.nixpkgs) lib;
        pkgs = inputs.nixpkgs.legacyPackages.${system};
      in {
        packages = {
          docs = import ./docs {inherit pkgs inputs lib;};
        };
      }
    );
}
