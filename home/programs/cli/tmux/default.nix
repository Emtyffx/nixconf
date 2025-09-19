{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    terminal = "xterm-256color";
    tmuxinator.enable = true;
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
      bind -n S-Left previous-window
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

      # Status Bar (Gruvbox colors)
      set -g status-left '#[fg=#282828,bg=#d79921,bold]  #{session_windows} #[bg=#282828,fg=#d79921,bold] '
      set -g status-right '#[fg=#282828,bold] [#S]#[fg=#ebdbb2,bold] %d/%m #[fg=#282828,bg=#3c3836,bold]#[fg=#ebdbb2,bg=#3c3836,bold] %I:%M %p '
      set -g status-style fg='#ebdbb2',bg='#282828'
      set-option -g status-position top

      set -g window-status-current-style fg='#fabd2f',bg='#282828',bold
      setw -g window-status-current-format '  #W '

      set -g window-status-style fg='#ebdbb2',bg='#504945'
      setw -g window-status-format '#[fg=#928374,bg=#282828,bold]  #W '
      setw -g window-status-separator '''

      set -g pane-border-style fg='#282828'
      set -g pane-active-border-style fg='#ebdbb2'

      set -g message-style fg='#ebdbb2',bg='#282828'

      set -g display-panes-active-colour '#ebdbb2'
      set -g display-panes-colour '#ebdbb2'

      set -g clock-mode-colour '#ebdbb2'
      set -g mode-style fg='#282828',bg='#665c54'

      TMUX_FZF_LAUNCH_KEY="C-f";
    '';
  };
}
