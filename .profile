export PATH="${HOME}/bin:$PATH"

export HISTFILESIZE=10000
export HISTSIZE=10000

if [ -e ~/.bashrc ]
then
   # Login shells on Debian use dash to source .xsessionrc which, in turn, sources .profile so we can't use any
   # bash-specific stuff here. Also we check $PS1 so we don't bother running .bashrc if it's not an interactive
   # login.
   if [ -n $BASH -a -n $PS1 ]
   then
       . ~/.bashrc
   fi
fi

if [ -e ~/.volta ]
then
   export VOLTA_HOME=${HOME}/.volta
   export PATH="$PATH:$VOLTA_HOME/bin"
fi

# For config that's local to a machine and not otherwise shared (e.g. work specific setttings)
if [ -e ~/.bash_profile_local ]
then
    . ~/.bash_profile_local
fi

# For pipx
export PATH=$PATH:$HOME/.local/bin

# Flush command history to ~/.bash_history on each new command prompt
# so that multiple terms can see each other's history and history isn't
# lost if I kill a shell instead of logging out.
export PROMPT_COMMAND='history -a'


if [ -e ~/.profile.companion ]
then
   . ~/.profile.companion
fi
# BEGIN ANSIBLE MANAGED for golang
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
# END ANSIBLE MANAGED for golang
