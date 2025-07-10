{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    terminal = "xterm-256color";
    shell = "${pkgs.zsh}/bin/zsh";
    historyLimit = 100000;
    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
      tmux-colors-solarized
      yank
      sensible
      tmux-fzf
    ];
    extraConfig = ''
      # Make split keys better
      unbind % 
      unbind '"'
      bind '\' split-window -h -c '#{pane_current_path}'           
      bind '-' split-window -v -c '#{pane_current_path}'

      # Quickly move through panes with ALT+Arrow Key
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D

      # Shift arrow to switch windows
      bind -n S-Left  previous-window
      bind -n S-Right next-window

      # r to reload config
      unbind r
      bind r source-file ~/.config/tmux/tmux.conf \; display "Reloaded tmux config!"

      # set mode-keys
      set -g mode-keys vi
      bind 'v' copy-mode

      # configure vim-like navigation
      bind -r ^ last-window
      bind -r k select-pane -U
      bind -r j select-pane -D
      bind -r l select-pane -R
      bind -r h select-pane -L

      # configure creating new window

      bind -r o neww -c "#{pane_current_path}"

      # configure closing all panes

      bind -r e kill-pane -a

      # Automatically set the window title
      set-window-option -g automatic-rename off

      # activity notifications
      setw -g monitor-activity on
      setw -g visual-activity on

      # Improve terminal colors
      set -g default-terminal "screen-256color"
      set -ga terminal-overrides ",xterm-256color:Tc"

      # Increase scrollback buffer to 10000
      set -g history-limit 10000

      # Mouse mode
      set -g mouse on

      # Silence
      set -g visual-activity off
      set -g visual-bell off
      set -g visual-silence off
      setw -g monitor-activity off
      set -g bell-action none

      # Status Bar
      set -g status-left '#[fg=#1F1F28,bg=#DCA561,bold]  #{session_windows} #[bg=#1F1F28,fg=#DCA561,bold] '
      set -g status-right '#[fg=#1F1F28,bold] [#S]#[fg=#C8C093,bold] %d/%m #[fg=#1F1F28,bg=#2A2A37,bold]#[fg=#C8C093,bg=#2A2A37,bold]  %I:%M %p '
      set -g status-style fg='#C8C093',bg='#1F1F28'
      set-option -g status-position top

      set -g window-status-current-style fg='#E6C384',bg='#1F1F28',bold
      setw -g window-status-current-format '  #W '

      set -g window-status-style fg='#C8C093',bg='#49443C'
      setw -g window-status-format '#[fg=#717C7C,bg=#1F1F28,bold]  #W '

      setw -g window-status-separator '''

      set -g pane-border-style fg='#1F1F28'
      set -g pane-active-border-style fg='#C8C093'

      set -g message-style fg='#C8C093',bg='#1F1F28'

      set -g display-panes-active-colour '#C8C093'
      set -g display-panes-colour '#C8C093'

      set -g clock-mode-colour '#C8C093'

      set -g mode-style fg='#1F1F28',bg='#3D4042'
      TMUX_FZF_LAUNCH_KEY="C-f";

    '';
  };
}
