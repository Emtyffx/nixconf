{ pkgs, lib, ... }:
{
  accounts.calendar.basePath = ".calendar";
  accounts.calendar.accounts = {
    school = {
      khal = {
        enable = true;
        addresses = [ "p.verbytsky@gmail.com" ];
        color = "#FF0000";
      };
      vdirsyncer.enable = true;
    };
  };
  programs.khal = {
    enable = true;
  };
}
