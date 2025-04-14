{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    terminal = "xterm-256color";
    shell = "${pkgs.bash}/bin/bash";
    historyLimit = 100000;
    plugins = with pkgs; [
      tmuxPlugins.vim-tmux-navigator
      tmuxPlugins.tmux-colors-solarized
      tmuxPlugins.catppuccin
      tmuxPlugins.yank
      tmuxPlugins.sensible
    ];
    extraConfig = ''
      bind -n M-H previous-window
      bind -n M-L next-window

      bind o run-shell "open #{pane_current_path}"
      bind -r e kill-pane -a
      bind '"' split-window -v -c "#{pane_current_path}"
      bind '%' split-window -h -c "#{pane_current_path}"

      set-window-option -g mode-keys vi
      set -ga terminal-overrides ",xterm-256color:Tc"
    '';
  };
}
