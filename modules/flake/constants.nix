{ lib, ... }: {
  options.flake.constants = lib.mkOption {
    type = lib.types.attrsOf lib.types.unspecified;
    default = { };
  };

  config = {
    flake.constants.rootPath = ../..;
  };
}
