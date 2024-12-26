localFlake: {self, ...}: {
  flake.homeManagerModules.default = _: {
    imports = [(self.outPath + "modules/homeManager")];
  };
}
