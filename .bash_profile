
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

# If the shell supports the globstar option (older bash shells do not including the
# one on OSX) then set it so that "**" match all files and zero or more directories
# and subdirectories.
if shopt | grep -q globstar
then
   shopt -sq globstar
fi

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

if [ -f ~/.bashrc ]; then
   source ~/.bashrc
fi

export PATH="$HOME/.poetry/bin:$PATH"

if [[ -e ~/.bashrc_os_specific ]]
then
    source ~/.bashrc_os_specific
fi
