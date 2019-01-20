
# added by Anaconda3 4.4.0 installer
if [[ $(uname -s) = "Darwin" ]]
then
   export PATH="/Users/oliverdain/bin:/Users/oliverdain/anaconda/bin:$PATH"
else
   export PATH="/home/oliver/bin:$PATH"
fi

export HISTFILESIZE=10000
export HISTSIZE=10000
HISTCONTROL=ignoreboth
shopt -s histappend

# match all files and zero or more directories and subdirectories.
shopt -s globstar

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

if [ -f ~/.bashrc ]; then
   source ~/.bashrc
fi
