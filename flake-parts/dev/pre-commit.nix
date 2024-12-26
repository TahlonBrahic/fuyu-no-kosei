{
  pre-commit-hooks,
  system,
}: {
  pre-commit-check = pre-commit-hooks.lib.${system}.run {
    src = ./.;
    default_stages = ["pre-commit"];
    hooks = {
      detect-private-keys.enable = true;
      end-of-file-fixer.enable = true;
      sort-file-contents.enable = true;
      trim-trailing-whitespace.enable = true;
      typos.enable = true;
    };
  };
}
