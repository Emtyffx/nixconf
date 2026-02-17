{ config, inputs, ... }:
{
  flake.modules.nixos.steam =
    { pkgs, ... }:
    {
      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        extraCompatPackages = with pkgs; [ proton-ge-bin ];
      };
      hardware.steam-hardware.enable = true;

      environment.systemPackages = with pkgs; [ steam-run ];
    };
}
