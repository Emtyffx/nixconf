{ inputs, config, ... }:
{
  flake.modules.nixos.laptop =
    { lib, ... }:
    {
      imports = [
        config.flake.modules.nixos.pc
      ];

      services.power-profiles-daemon.enable = true;

      powerManagement = {
        enable = true;
        cpuFreqGovernor = lib.mkDefault "powersave";
      };
      # required for hibernation
      # boot.resumeDevice = "/dev/mapper/crypted";

      services.logind = {
        settings.Login = {
          HandleLidSwitch = "suspend-then-hibernate";
          HandleLidSwitchExternalPower = "suspend";
          HandlePowerKey = "suspend-then-hibernate";
          IdleAction = "suspend-then-hibernate";
          IdleActionSec = "15min";
        };
      };

      systemd.sleep.extraConfig = ''
        AllowSuspend=yes
        AllowHibernation=yes
        AllowSuspendThenHibernate=yes
        AllowHybridSleep=yes
        HibernateDelaySec=30min
      '';

      services.upower = {
        enable = true;
        percentageLow = 15;
        percentageCritical = 5;
        percentageAction = 3;
        criticalPowerAction = "Hibernate";
      };
    };
}
