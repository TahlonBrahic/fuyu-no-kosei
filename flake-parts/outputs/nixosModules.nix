localFlake: {self, ...}: {
  flake.nixosModules.default = _: {
    imports = [(self.outPath + "modules/homeManager")];
  };
}
