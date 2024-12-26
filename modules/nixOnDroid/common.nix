{pkgs, ...}: {
  environment = {
    etcBackupExtension = ".bak";
    motd = "";
  };

  user.shell = "${pkgs.fish}/bin/fish";

  # Set up nix for flakes
  nix.extraOptions = ''
    experimental-features = nix-command flakes
    warn-dirty = false
  '';

  # Setting terminal colors
  terminal.colors = {
    "foreground" = "#ebdbb2";
    "background" = "#282828";
    "color0" = "#665c54";
    "color1" = "#fb4934";
    "color10" = "#b8bb26";
    "color11" = "#fabd2f";
    "color12" = "#83a598";
    "color13" = "#d3869b";
    "color14" = "#8ec07c";
    "color15" = "#fbf1c7";
    "color2" = "#b8bb26";
    "color3" = "#fabd2f";
    "color4" = "#83a598";
    "color5" = "#d3869b";
    "color6" = "#8ec07c";
    "color7" = "#ebdbb2";
    "color8" = "#665c54";
    "color9" = "#fb4934";
  };

  system.stateVersion = "24.05";
}
