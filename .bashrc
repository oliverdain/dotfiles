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

if [[ -e ~/Documents/code/usefuls/bash/bin/kns ]]
then
   source ~/Documents/code/usefuls/bash/bin/kns
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

# set +x
# exec 2>&3 3>&-
