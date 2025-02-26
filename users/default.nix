{pkgs, ...}:
{
  users.users.paul = {
    isNormalUser = true;
    description = "Pavel Verbytsky";
    extraGroups = [ "networkmanager" "wheel" "audio" "video" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };
  home-manager.useGlobalPkgs = true;
  home-manager.users = {
    paul = import ./paul.nix;
  };
}
