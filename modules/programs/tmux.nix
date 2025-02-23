{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    prefix = "C-a";
    mouse = true;
    keyMode = "vi";
    baseIndex = 1;
    escapeTime = 0;
    customPaneNavigationAndResize = true;
    
    # Add plugins
    plugins = with pkgs.tmuxPlugins; [
      resurrect          # Restore tmux environment after system restart
      continuum         # Continuous saving of tmux environment
      yank             # Easy text copying
      tilish           # Automatic tiling and navigation
      fzf-tmux-url    # Quickly open URLs
      vim-tmux-navigator # Better vim integration
    ];
    
    extraConfig = ''
      # Split panes
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      unbind '"'
      unbind %

      # Vim-like pane navigation
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # Resize panes
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5

      # Quick window selection
      bind -r C-h select-window -t :-
      bind -r C-l select-window -t :+
      
      # Better window management
      bind C new-window -c "#{pane_current_path}"  # New window in current path
      bind b break-pane -d                         # Break pane to new window
      bind B command-prompt -p "join pane from:"  "join-pane -s '%%'"  # Join pane from window
      bind S command-prompt -p "send pane to:"  "join-pane -t '%%'"    # Send pane to window
      
      # Session management
      bind C-j choose-tree -Zs  # Interactive session/window selection
      bind C-b send-keys 'tat && exit' 'C-m'  # Reattach to existing session or create new
      bind C-s command-prompt -p "New Session:" "new-session -A -s '%%'"
      
      # Copy mode improvements
      bind Enter copy-mode # Enter copy mode
      bind -T copy-mode-vi v send -X begin-selection
      bind -T copy-mode-vi y send -X copy-pipe-and-cancel "xclip -selection clipboard"
      bind -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "xclip -selection clipboard"
      bind p paste-buffer
      
      # Mouse behavior
      set -g mouse on
      bind -n WheelUpPane if-shell -F -t = "#{mouse_any_flag}" "send-keys -M" "if -Ft= '#{pane_in_mode}' 'send-keys -M' 'copy-mode -e'"
      
      # Better terminal behavior
      set -g focus-events on
      set -g aggressive-resize on
      set -s set-clipboard on
      set -g history-limit 50000
      set -g display-time 4000
      set -g status-interval 5
      set -g default-terminal "tmux-256color"
      set -ag terminal-overrides ",xterm-256color:RGB"
      
      # Activity monitoring
      set -g monitor-activity on
      set -g visual-activity off
      set -g bell-action none
      
      # statusbar styling
      set -g status-position top
      set -g status-justify left
      set -g status-style 'bg=#00060e fg=#9a9f17'
      set -g status-left "#[fg=#c5003c,bold] [#S] "
      set -g status-right "#[fg=#39c4b6]#{?window_zoomed_flag,[Z] ,}#[fg=#fee801]%H:%M #[fg=#c5003c]%d-%b"
      set -g status-left-length 30
      set -g status-right-length 50
      
      # Hide status bar when only one window is present (useful when using WezTerm tabs)
      if -F "#{==:#{window_panes},1}" "set -g status off" "set -g status on"
      set-hook -g window-linked 'if -F "#{==:#{window_panes},1}" "set -g status off" "set -g status on"'
      set-hook -g window-unlinked 'if -F "#{==:#{window_panes},1}" "set -g status off" "set -g status on"'
      set-hook -g pane-exited 'if -F "#{==:#{window_panes},1}" "set -g status off" "set -g status on"'
      
      # Window status styling
      set-window-option -g window-status-style 'fg=#384048 bg=#00060e'
      set-window-option -g window-status-current-style 'fg=#c5003c bg=#1c1c28 bold'
      set-window-option -g window-status-activity-style 'fg=#fee801 bg=#00060e'
      set-window-option -g window-status-format ' #I:#W#{?window_flags,#{window_flags}, } '
      set-window-option -g window-status-current-format ' #I:#W#{?window_flags,#{window_flags}, } '
      
      # Pane styling
      set -g pane-border-style 'fg=#384048'
      set -g pane-active-border-style 'fg=#fee801'
      set -g pane-border-format ' #{?pane_active,#[fg=#fee801],#[fg=#384048]}#{pane_index} #{pane_current_command} '
      
      # Message styling
      set -g message-style 'fg=#c5003c bg=#00060e bold'
      set -g message-command-style 'fg=#fee801 bg=#00060e bold'
      
      # Selection styling
      set -g mode-style 'fg=#00060e bg=#fee801 bold'
      
      # Smart pane switching with awareness of Vim splits
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
          | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?)(diff)?$'"
      bind -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
      bind -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
      bind -n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
      bind -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'
      
      # Plugin configurations
      # Resurrect configuration
      set -g @resurrect-capture-pane-contents 'on'
      set -g @resurrect-strategy-nvim 'session'
      
      # Continuum configuration
      set -g @continuum-restore 'on'
      set -g @continuum-save-interval '10'
      
      # Tilish configuration
      set -g @tilish-default 'main-vertical'
      
      # Session name in terminal title
      set -g set-titles on
      set -g set-titles-string "#S / #W"
    '';
  };
} 