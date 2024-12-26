{
  inputs,
  lib,
  ...
} @ arguments: let
  data = inputs.haumea.lib.load {
    src = ./systems;
    inputs = arguments;
  };

  systems = lib.attrsets.mergeAttrsList (map (it: it) (builtins.attrValues data));
  systemConfigurations = builtins.attrValues systems;

  outputs = {
    nixosConfigurations = lib.attrsets.mergeAttrsList (map (it: it.nixosConfigurations) systemConfigurations);
  };
in
  outputs // {inherit data;}
