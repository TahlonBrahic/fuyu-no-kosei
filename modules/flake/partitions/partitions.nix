{
  partitions = {
    dev = {
      module = ./dev;
      extraInputsFlake = ./dev;
    };
  };

  partitionedAttrs = {
    checks = "dev";
    devShells = "dev";
    formatter = "dev";
    herculesCI = "dev";
  };
}
