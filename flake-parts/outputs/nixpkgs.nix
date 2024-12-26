{
  config,
  inputs,
  lib,
  self,
  ...
}: {

  /*
  A central set of nixpkgs instance for all systems. It's made available as flake-parts module
  argument and intended to be used everywhere where nixpkgs is needed, so less duplicated instances
  have to be created and there's only one central nixpkgs config.

  Note that this is a top-level flake-parts module argument, not a `perSystem` argument, because
  it's not created per system, instead it has all systems at once.
  */

  _module.args.pkgsBySystem = lib.attrsets.genAttrs config.systems (
    system:
      import inputs.nixpkgs {
        localSystem = system;
        hostPlatform = system;

        overlays =
		  [self.overlays.default] ++
          lib.optional (system == "x86_64-linux") inputs.lix-module.overlays.default;
        config = {
          allowUnfree = true;
          allowBroken = true;
          tarball-ttl = 0;
          contentAddressedByDefault = false;
        };
      };
 # pkgs = system:
 #   import inputs.nixpkgs {
 #     inherit system;
 #     inherit (lib.${system}.overlays) overlays;
 #     config.allowUnfree = true;
 #   };
 # );

}
