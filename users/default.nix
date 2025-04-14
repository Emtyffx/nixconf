{
  self,
  pkgs,
  inputs,
  ...
}:
{
  programs.zsh.enable = true;
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
    shell = pkgs.zsh;
  };
  home-manager.extraSpecialArgs = { inherit self inputs; };
  home-manager.useGlobalPkgs = true;
  home-manager.users = {
    paul = {
      imports = [
        ./paul.nix
      ];
    };
  };
}
