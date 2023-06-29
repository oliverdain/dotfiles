export PATH="/home/oliver/bin:$PATH"

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

if [[ -e ~/.bashrc ]]
then
    source ~/.bashrc
fi

# For config that's local to a machine and not otherwise shared (e.g. work specific setttings)
if [[ -e ~/.bash_profile_local ]]
then
    source ~/.bash_profile_local
fi

# For pipx
export PATH=$PATH:$HOME/.local/bin

# Flush command history to ~/.bash_history on each new command prompt
# so that multiple terms can see each other's history and history isn't
# lost if I kill a shell instead of logging out.
export PROMPT_COMMAND='history -a'


export PATH="$HOME/.poetry/bin:$PATH"
# BEGIN ANSIBLE MANAGED for pipx
export PATH=$PATH:$HOME/.local/bin
# END ANSIBLE MANAGED for pipx

if [[ -e ~/.profile.companion ]]
then
   source ~/.profile.companion
fi
