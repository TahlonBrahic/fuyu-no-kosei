{
  inputs = {
    # Editor
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvchad4nix = {
      url = "github:nix-community/nix4nvchad";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    jeezyvim = {
      url = "github:LGUG2Z/JeezyVim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fuyuvim = {
      url = "github:TahlonBrahic/fuyu-no-neovim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
