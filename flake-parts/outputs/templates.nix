{
  templates = {
    default = {
      path = ./templates/default;
      description = ''
        A template that includes examples for all systems
      '';
      welcomeText = ''
      '';
    };
    WSL = {
      path = ./templates/WSL;
      description = ''
        A template containing an example only for a single WSL host
      '';
      welcomeText = ''
      '';
    };
  };
}
