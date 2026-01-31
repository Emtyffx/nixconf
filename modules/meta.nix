{ lib, ... }:
{
  options.flake.meta = lib.mkOption {
    type = lib.types.anything;
    description = "Metadata";
  };

  config.flake.meta = {
    owner = {
      username = "paul";
      name = "Pavel";
      email = "p.verbytsky@gmail.com";
    };

    defaults = {
      shell = "zsh";
      editor = "nvim";
      fileManager = "nautilus";

      terminal = "kitty";
      browser = "helium-browser";

      timezone = "Europe/Kyiv";
      locale = "en_US.UTF-8";

      stateVersion = "25.11";

    };
  };
}
