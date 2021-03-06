# These lines and the ones at the end of the file can be uncommented to get timestamp line-by-line
# tracing of this startup script written to /tmp/bashstart.PID.log so I can
# debug why .bashrc is sometimes slow.

# PS4='+ $(/usr/local/bin/gdate "+%s.%N")\011 '
# exec 3>&2 2>/tmp/bashstart.$$.log
# set -x

alias ll="ls -lh"
alias lf="ls -F"
alias ipy="ipython --matplotlib=qt5"
alias lint="bazel test --test_tag_filters=lint"

alias nq=nvim-qt

# Defines a function that lets you search for a file walking "up" directories.
# For example, if you call "find_up foo" this will start with pwd and, if pwd
# contains a file named "foo" this will echo to stdout `pwd`. If `pwd` does
# not contain a file named foo the directory above `pwd` is then checked
# and so on until the file is found.
find_up() {
   if [ $# -ne 1 ]
   then
      echo "Error: You must supply exactly 1 argument."
      return 1
   fi

   dir=`pwd`
   while [ ! -e ${dir}/$1 ]
   do
      dir=${dir%/*}
   done

   if [ -e $dir ]
   then
      echo "$dir"
   else
      echo "Error: $1 not found" 2>&1
      return 1
   fi
}

alias g='$(find_up settings.gradle)/gradlew'

source ~/bin/git-completion.bash
alias findc="find . \( -name build -type d -prune \) -o \( -name '*.h' -o -name '*.cpp' \)"
alias mpv_with_time='mpv --osd-level=2 --osd-fractions'
alias mpv_with_millis='mpv --osd-level=2 --osd-msg2="\${=time-pos}"'
alias mpv_with_frame='mpv --ods-level=2 --osd-msg2="\${estimated-frame-number}"'
alias act='source $(find_up venv)/venv/bin/activate'

if command -v kubectl > /dev/null
then
    source <(kubectl completion bash)
fi

if [[ -e ~/.bashrc_os_specific ]]
then
    source ~/.bashrc_os_specific
fi

if [[ -f ~/.fzf.bash ]]
then
   source ~/.fzf.bash
   # Add completion for vv
   complete -o bashdefault -o default -F _fzf_path_completion vv
fi

# Some history stuff (see .bash_profile for the other half and links
# to references)
# Remove duplicates from the history file when saving.
HISTCONTROL=ignoreboth

# Function to reload the bash history so the history in one terminal
# contains commands from the others (assumes the PROMPT_COMMAND hack
# that's in ~/..bash_profile.
hr() {
   builtin history -a
   builtin history -c
   builtin history -r
}

# fasd setup https://github.com/clvv/fasd/blob/master/README.md
FASD_LOC=$(which fasd)
if [[ $? && -e $FASD_LOC ]]
then
   eval "$($FASD_LOC --init auto)"
   alias v='f -e $EDITOR'
fi

# set +x
# exec 2>&3 3>&-
# BEGIN ANSIBLE MANAGED for pyenv
if command -v pyenv 1>/dev/null 2>&1
then
    eval "$(pyenv init -)"
fi
# END ANSIBLE MANAGED for pyenv

# add Pulumi to the PATH
if [[ -e $HOME/.pulumi ]]
then
   export PATH=$PATH:$HOME/.pulumi/bin
fi

# Defines an rgf function. Called with one argument it used ripgrep to find files whose name match the given pattern.
# Called with 2 arguments it searches for files whose name match the first argument in subdirectories of the 2nd
# argument.
rgf() {
  if [ -z "$2" ]
  then
      rg --files | rg "$1"
  else
      rg --files "$2" | rg "$1"
  fi
}
