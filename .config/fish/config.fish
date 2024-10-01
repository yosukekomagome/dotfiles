if status is-interactive
  # Commands to run in interactive sessions can go here
  alias vim='nvim'
  alias debugchrom='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --remote-debugging-port=9222'
  alias ll='eza -l -F --icons --sort=type --time-style iso'
  alias lla='eza -a -l -F --icons --sort=type --time-style iso'
  abbr -a glog git log --graph --oneline --all
  abbr -a reload source ~/dotfiles/.config/fish/config.fish
end

