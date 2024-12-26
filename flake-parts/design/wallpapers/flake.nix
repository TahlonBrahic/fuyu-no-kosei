{
  description = "A partition that imports a large repository of wallpapers";

  outputs = {inputs, ...}: {
    
  };

  inputs = {
    walls = {
      url = "github:dharmx/walls";
      flake = false;
    };
  };
}
