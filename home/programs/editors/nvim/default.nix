{ pkgs, lib, ... }:
let
  nvim-pkg = import ../../../../nvim {inherit pkgs; };
in
{
  home.packages = with pkgs; lib.mkBefore [ nvim-pkg ];
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
  xdg = {
    configFile."nvim".source = ../../../../nvim;
    configFile."nvim".recursive = true;
    configFile."nvim".target = "nvim";

    desktopEntries."nvim" = lib.mkIf pkgs.stdenv.isLinux {
      name = "Neovim";
      comment = "Best text editor";
      icon = "nvim";
      exec = "${nvim-pkg}/bin/nvim %F";
      terminal = true;
      categories = [ "TerminalEmulator" ];
      mimeType = [ "text/plain" ];
    };
  };
}
