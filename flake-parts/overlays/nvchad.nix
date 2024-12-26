{
  inputs,
  system,
  ...
}: (final: prev: {
  inherit (inputs.nvchad4nix.packages."${system}".nvchad) nvchad;
})
