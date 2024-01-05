#!/bin/bash

# If you're using git worktrees you can't check out the same branch in more than one worktree which can be a pain.
# This is a quick script, usually used with a git alias like:
#
#
# [alias]
#    parkall = "!~/bin/git_park.sh"
#
# It finds any worktree with main checked out and instead checks out a new branch (at the same commit) named "park"
# with a date/time suffix.

main_dir=$(git worktree list | grep main | cut -d' ' -f1)

# When run via a git alias git sets several environment variables which can mess things up. Unset them.
for ev in $(env)
do
   ev=${ev%=*}
   if [[ $ev =~ ^GIT_ ]]
   then
      unset $ev
   fi
done

if [[ -n $main_dir ]]
then
   echo "Parking $main_dir"
   git -C $main_dir checkout -b parked-$(date +%Y-%M-%dT%H.%m.%S)
fi
