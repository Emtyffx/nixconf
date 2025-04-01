{ pkgs, inputs, ... }:
{
  users.users.paul = {
    isNormalUser = true;
    description = "Pavel Verbytsky";
    extraGroups = [
      "networkmanager"
      "wheel"
      "audio"
      "video"
      "libvirtd"
      "docker"
    ];
    packages = with pkgs; [
      #  thunderbird
    ];
  };
  home-manager.extraSpecialArgs = { inherit inputs; };
  home-manager.useGlobalPkgs = true;
  home-manager.users = {
    paul = {
      imports = [
        ./paul.nix
      ];
    };
  };
}
