{ config, ... }:
let
  nixosModules = config.flake.modules.nixos;
  diskoModules = config.flake.diskoConfigurations;
  meta = config.flake.meta;
in
{
  configurations.nixos.pc = {
    system = "x86_64-linux";
    modules = [
      nixosModules.pc
      diskoModules.pc
      (
        { config, ... }:
        {
          home-manager.users.${meta.owner.username} = {

            hyprland.monitors = [
              {
                name = "DP-1";
                width = 3840;
                height = 2160;
                refreshRate = 60;
                x = 0;
                y = 0;
                scale = 1.25;
                transform = "normal";
                vrr = 0;
                hdr = false;
                primary = true;
                enabled = true;

              }
              {
                name = "DP-2";
                width = 3840;
                height = 2160;
                refreshRate = 60;
                x = -3072;
                y = 0;
                scale = 1.25;
                transform = "normal";
                vrr = 0;
                hdr = false;
                primary = false;
                enabled = true;

              }
            ];
          };
        }
      )
    ];
  };
}
