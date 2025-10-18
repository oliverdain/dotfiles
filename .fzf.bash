# Setup fzf
# ---------
if [[ ! "$PATH" == */home/oliver/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/oliver/.fzf/bin"
fi

eval "$(fzf --bash)"
