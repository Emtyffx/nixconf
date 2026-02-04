{ inputs, config, ... }:
{
  flake.modules.nixos.printer =
    { lib, pkgs, ... }:
    {
      services.printing.enable = true;
      services.printing.drivers = with pkgs; [ hplip ];
      hardware.printers = {
        ensurePrinters = [
          {
            name = "HP_LaserJet_1320";
            location = "Home";
            deviceUri = "socket://192.168.20.3:9100";
            model = "drv:///hp/hpcups.drv/hp-laserjet_1320.ppd";
            ppdOptions = {
              PageSize = "A4";
            };
          }
        ];
      };
    };
}
