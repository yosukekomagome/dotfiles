function ide
  tmux split-window -v -l 25%
  tmux split-window -h -l 66%
  tmux split-window -h -l 50%

  tmux select-pane -t 0

  set wd (pwd)
  tmux send-key -t 1 "cd $wd && clear" C-m
  tmux send-key -t 2 "cd $wd && clear" C-m
  tmux send-key -t 3 "cd $wd && clear" C-m

  tmux rename -t 0 IDE
end

