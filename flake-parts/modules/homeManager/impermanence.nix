{
  config,
  inputs,
  lib,
  ...
}: let
  cfg = config.fuyuNoKosei.impermanence;
in {
  imports = [inputs.impermanence.homeManagerModules.impermanence];

  options = {
    fuyuNoKosei.impermanence.enable = lib.mkEnableOption "impermanence";
  };

  config =
    lib.mkIf cfg.enable {
    };
}
