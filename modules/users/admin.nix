{
  config,
  inputs,
  ...
}:
let
  meta = config.flake.meta;
  homeModules = config.flake.homeModules;
in
{
  flake.homeConfigurations.${meta.owner.username} =
    { lib, pkgs, ... }:
    {
      imports = [
        homeModules.kitty
        homeModules.wlogout
        homeModules.rofi
        homeModules.nvim
        homeModules.hyprland
        homeModules.hyprlock
        homeModules.hypridle
        homeModules.waybar
        homeModules.zsh
      ];
      home = {
        username = meta.owner.username;
        homeDirectory = "/home/${meta.owner.username}";

        stateVersion = meta.defaults.stateVersion;
      };

      programs.git = {
        enable = true;
        settings = {
          # userName = meta.owner.name;
          # userEmail = meta.owner.email;

          core.editor = meta.defaults.editor;
        };
      };

      programs.lazygit.enable = true;
      programs.btop.enable = true;

      services.kdeconnect = {
        enable = true;
        indicator = true;
      };

      home.packages = with pkgs; [
        wl-clipboard
        go
        gnumake
        cmake
        bear

        # llvm.lldb
        gdb

        clang-tools

        # llvm.libstdcxxClang
        # llvm.libcxx

        rustc
        cargo

        yarn
        pnpm
        bun
        nodePackages_latest.nodejs

      ];

    };
}
