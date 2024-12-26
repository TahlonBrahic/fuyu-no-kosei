{
  inputs,
  system,
  pkgs,
}: let
  overlaySet = inputs.haumea.lib.load {
    src = ../overlays;
    inputs = {inherit inputs system pkgs;};
  };
  overlays = builtins.attrValues overlaySet;
in {inherit overlays;}
