{
  description = "NixOS configuration that follows fuyu-no-kosei.";

  inputs.fuyuNoKosei.url = "github:TahlonBrahic/fuyu-no-kosei";

  outputs = inputs: let
    inherit (inputs) fuyuNoKosei;
    inherit (fuyuNoKosei) pkgs forEachSystem genConfig nixosModules homeManagerModules;

    systemConfigurations = forEachSystem (system: import ./outputs/${system} args.${system});
    systemValues = builtins.attrValues systemConfigurations;

    args = forEachSystem (system: rec {
      inherit system;
      inputs = fuyuNoKosei.inputs // {inherit nixosModules homeManagerModules;};
      pkgs = fuyuNoKosei.pkgs.${system};
      lib = fuyuNoKosei.lib.${system};
    });

    formatter = forEachSystem (system: pkgs.${system}.alejandra);

    devShells = forEachSystem (system: import ./shell.nix {inherit (pkgs.${system}) pkgs;});

    nixosConfigurations = genConfig (map (it: it.nixosConfigurations or {}) systemValues);
    nixOnDroidConfigurations = genConfig (map (it: it.nixOnDroidConfigurations or {}) systemValues);
  in {
    inherit nixosConfigurations nixOnDroidConfigurations devShells formatter;
  };
}
