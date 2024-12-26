localFlake: _: {
  flake = {
    perSystem = {pkgs, ...}: {
      formatter = pkgs.alejandra;
    };
  };
}
