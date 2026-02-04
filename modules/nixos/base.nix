{ config, inputs, ... }:
let
  meta = config.flake.meta;
in
{
  flake.modules.nixos.base =
    {
      pkgs,
      lib,
      hostName,
      ...
    }:
    {
      boot.loader = {
        efi.canTouchEfiVariables = true;
        systemd-boot.enable = true;
      };

      security = {
        sudo.enable = true;
        polkit.enable = true;
      };
      networking = {
        networkmanager.enable = true;
      };

      time.timeZone = lib.mkDefault meta.defaults.timezone;
      i18n.defaultLocale = lib.mkDefault meta.defaults.locale;

      nix = {
        settings = {
          experimental-features = [
            "nix-command"
            "flakes"
          ];
          max-jobs = "auto";
          auto-optimise-store = true;
          warn-dirty = true;
        };
        gc = {
          automatic = true;
          dates = "weekly";
          options = "--delete-older-than 10d";
        };
      };

      nixpkgs.config.allowUnfree = true;

      environment.systemPackages = with pkgs; [
        curl
        wget
        vim
        git
        yazi
      ];

      system.stateVersion = lib.mkDefault meta.defaults.stateVersion;

      networking.hostName = hostName;

    };
}
