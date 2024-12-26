{
  importModules =
    map
    (module: (importApply "./${module}" {inherit withSystem;}))
    builtins.filter (x: x != "default.nix")
    (builtins.attrNames (builtins.readDir ./.));
}
