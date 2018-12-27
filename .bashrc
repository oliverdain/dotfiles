# These lines and the ones at the end of the file can be uncommented to get timestamp line-by-line
# tracing of this startup script written to /tmp/bashstart.PID.log so I can
# debug why .bashrc is sometimes slow.

# PS4='+ $(/usr/local/bin/gdate "+%s.%N")\011 '
# exec 3>&2 2>/tmp/bashstart.$$.log
# set -x

alias act='source activate'
alias dact='source deactivate'
alias ll="ls -lh"
alias lf="ls -F"
alias vlc=/Applications/VLC.app/Contents/MacOS/VLC

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
alias sync_to_s3='aws s3 sync --exclude='.DS_Store' /Volumes/RevlData/s3 s3://com.revl.video'
alias sync_from_s3='aws s3 sync s3://com.revl.video /Volumes/RevlData/s3'
alias findc="find . \( -name build -type d -prune \) -o \( -name '*.h' -o -name '*.cpp' \)"
alias mpv_with_time='mpv --osd-level=2 --osd-fractions'

# fasd setup https://github.com/clvv/fasd/blob/master/README.md
eval "$(fasd --init auto)"
alias v='f -e mvim'

export ANDROID_HOME=~/Library/Android/sdk

testonly() {
   g testOSXDebug --testArgs="--gtest_filter=$1"
}

# set +x
# exec 2>&3 3>&-
source <(kubectl completion bash)

# [ -f ~/.fzf.bash ] && source ~/.fzf.bash
