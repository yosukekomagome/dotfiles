function ide
  tmux rename -t 0 work
  tmux split-window -v -l 25%
  tmux split-window -h -l 66%
  tmux split-window -h -l 50%
  tmux select-pane -t 0
  nvim .
end

