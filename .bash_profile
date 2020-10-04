
# added by Anaconda3 4.4.0 installer
if [[ $(uname -s) = "Darwin" ]]
then
   export PATH="/Users/oliverdain/bin:/Users/oliverdain/anaconda3/bin:$PATH"
else
   export PATH="/home/oliver/bin:$PATH"
fi

export HISTFILESIZE=10000
export HISTSIZE=10000
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

# For config that's local to a machine and not otherwise shared (e.g. work specific setttings)
if [[ -e ~/.bashrc_local ]]
then
    source ~/.bashrc_local
fi

# A bunch of history stuff - inspried by
# https://unix.stackexchange.com/a/48116 and
# https://unix.stackexchange.com/a/18443


# Flush command history to ~/.bash_history on each new command prompt
# so that multiple terms can see each other's history and history isn't
# lost if I kill a shell instead of logging out.
export PROMPT_COMMAND='history -a'
