{ lib, ... }:

let
  devShells = (import ../dev-shells);
in
{
  options.flake.customDevShells = lib.mkOption {
    type = lib.types.anything;
    description = "Dev shells for various programming needs";

  };

  config.flake.customDevShells = devShells;
  config.flake.templates = devShells;

}
