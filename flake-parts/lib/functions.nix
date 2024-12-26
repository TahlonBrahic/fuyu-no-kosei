{inputs, ...}: let
  inherit (inputs) haumea;
  functions = haumea.lib.load {
    src = ./.;
    loader = haumea.lib.loaders.path;
  };
in
  functions
