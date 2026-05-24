# Zsh function to change directory using fzf and fd
fcd() {
  local dir
  dir="$(fd -t d | fzf)" || return
  cd "$dir"
}

export EDITOR=nvim
export VISUAL=nvim