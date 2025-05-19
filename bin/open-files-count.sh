#!/bin/bash

# Script to list running processes and their open file count
# Sorted by number of open files (highest first)

echo "Collecting data on open files per process..."
echo "PID   COUNT   COMMAND"
echo "-----------------------"

# Use lsof to count files per process ID, then sort numerically by count (descending)
lsof -n | awk '{print $2}' | grep -v PID | sort | uniq -c | sort -rn | while read count pid; do
    # Get the command name for each PID
    cmd=$(ps -p $pid -o comm= 2>/dev/null)
    
    # Only show processes that still exist and have open files
    if [ ! -z "$cmd" ] && [ $count -gt 0 ]; then
        printf "%-6s %-7s %s\n" "$pid" "$count" "$cmd"
    fi
done
