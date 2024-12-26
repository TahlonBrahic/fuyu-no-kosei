{flake-parts, ...} @ inputs: let
  inherit (flake-parts.flake-parts-lib) importApply withSystem;
in {
  systems = import inputs.systems;

  debug = true;

  imports = [
    flake-parts.flakeModules.flakeModules
    flake-parts.flakeModules.partitions
  ];

  flake = {
    inherit flakeModules;
    lib = (import ../lib {inherit inputs system pkgs;}).lib // inputs.nixpkgs.lib;
  };

  partitions = {
    partitions = {
      design = {
        module = ./design;
      };
      dev = {
        module = ./dev;
      };
      docs = {
        module = ./docs;
      };
      infrastructure = {
        module = ./infrastructure;
      };
      installer = {
        module = ./installer;
      };
      wallpapers = {
        module = ./wallpapers;
      };
    };

    partitionedAttrs = {
      pre-commit = "dev";
      formatter = "dev";
      shell = "dev";
      wallpapers = "wallpapers";
    };
  };
}
