{ inputs, config, ... }:
{
  flake.homeModules.tmux =
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
          unbind %
          unbind '"'
          bind '\' split-window -h -c '#{pane_current_path}'
          bind '-' split-window -v -c '#{pane_current_path}'

          bind -n M-Left select-pane -L
          bind -n M-Right select-pane -R
          bind -n M-Up select-pane -U
          bind -n M-Down select-pane -D

          bind -n S-Left previous-window
          bind -n S-Right next-window

          unbind r
          bind r source-file ~/.config/tmux/tmux.conf \; display "Reloaded tmux config!"

          set -g mode-keys vi
          bind 'v' copy-mode

          bind -r ^ last-window
          bind -r k select-pane -U
          bind -r j select-pane -D
          bind -r l select-pane -R
          bind -r h select-pane -L

          bind -r o neww -c "#{pane_current_path}"
          bind -r e kill-pane -a

          set-window-option -g automatic-rename off

          setw -g monitor-activity on
          setw -g visual-activity on

          set -g default-terminal "screen-256color"
          set -ga terminal-overrides ",xterm-256color:Tc"

          set -g history-limit 10000

          set -g mouse on

          set -g visual-activity off
          set -g visual-bell off
          set -g visual-silence off
          set -g monitor-activity off
          set -g bell-action none

          set -g status-left '#[fg=#282828,bg=#8ec07c,bold]  #{session_windows} #[bg=#282828,fg=#8ec07c,bold] '
          set -g status-right '#[fg=#8ec07c,bold] [#S]#[fg=#ebdbb2,bold] %d/%m #[fg=#282828,bg=#8ec07c,bold] %I:%M %p '
          set -g status-style fg='#ebdbb2',bg='#282828'

          set -g window-status-current-style fg='#8ec07c',bg='#282828',bold
          setw -g window-status-current-format '  #W '

          set -g window-status-style fg='#ebdbb2',bg='#3c3836'
          setw -g window-status-format '#[fg=#928374,bg=#282828,bold]  #W '
          setw -g window-status-separator '''

          set -g pane-border-style fg='#3c3836'
          set -g pane-active-border-style fg='#8ec07c'

          set -g message-style fg='#ebdbb2',bg='#282828'

          set -g display-panes-active-colour '#8ec07c'
          set -g display-panes-colour '#3c3836'

          set -g clock-mode-colour '#8ec07c'
          set -g mode-style fg='#282828',bg='#8ec07c'

          TMUX_FZF_LAUNCH_KEY="C-f"
        '';
      };
    };
}
