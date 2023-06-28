#!/bin/bash

# If you're using git worktrees you can't check out the same branch in more than one worktree which can be a pain.
# This is a quick script, usually used with a git alias like:
#
#
# [alias]
#    parkall = "!~/bin/git_park.sh"
#
# It finds any worktree with master checked out and instead checks out a new branch (at the same commit) named "park"
# with a date/time suffix.

master_dir=$(git worktree list | grep master | cut -d' ' -f1)

# When run via a git alias git sets several environment variables which can mess things up. Unset them.
for ev in $(env)
do
   ev=${ev%=*}
   if [[ $ev =~ ^GIT_ ]]
   then
      unset $ev
   fi
done

if [[ -n $master_dir ]]
then
   echo "Parking $master_dir"
   git -C $master_dir checkout -b parked-$(date +%Y-%M-%dT%H.%m.%S)
fi
