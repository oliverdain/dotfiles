# These lines and the ones at the end of the file can be uncommented to get timestamp line-by-line
# tracing of this startup script written to /tmp/bashstart.PID.log so I can
# debug why .bashrc is sometimes slow.

# PS4='+ $(/usr/local/bin/gdate "+%s.%N")\011 '
# exec 3>&2 2>/tmp/bashstart.$$.log
# set -x

shopt -s globstar
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
shopt -s histappend

alias ll="ls -lh"
alias lf="ls -F"
alias ipy="ipython --matplotlib=qt5"

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

# A function to run pants test with output in --debug mode. Takes n arguments: the first is the target to test and the
# rest go after the `-- -s` (e.g. so you can add a `-k some_test` to run a single test).
pt() {
   if [[ $# -lt 1 ]]
   then
      echo "You must provide a target. You may also provide other args to pass directly to pytest."
      return 1
   fi
   targ=$1
   shift
   ./pants test --debug --test-output=all $targ -- -s "$@"
}

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

# Let's me have local config that's not checked into yadm for machine-specific stuff.
if [[ -e ~/.local_bashrc ]]
then
   . ~/.local_bashrc
fi

if [[ -e ~/.bash_kube ]]
then
   . ~/.bash_kube
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

if [[ -e ~/.bashrc.companion ]]
then
   source ~/.bashrc.companion
fi

# Switcher k8's context/namespace manager. My Ansible will install it. See https://github.com/danielfoehrKn/kubeswitch.
if [[ -e ~/bin/switcher ]]
then
   source <(~/bin/switcher init bash)
fi

