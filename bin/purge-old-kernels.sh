#!/bin/bash

# Script to purge all but the 3 most recent kernels on the machine. Handy when /boot fills up.

# Exit on any error
set -e

# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root or with sudo"
    exit 1
fi

# Get list of installed kernels (excluding the currently running kernel)
current_kernel=$(uname -r)
echo "Current kernel: $current_kernel (will be kept)"

# List all installed kernels, sort by version, and get the 3 oldest
echo "Finding 3 oldest kernels..."
kernels_to_remove=$(dpkg --list | grep -E 'linux-image-[0-9]' | grep -v "$current_kernel" | tr -s ' ' | cut -f2 -d' ' | sort -V | head -n -3)

# Check if we found any kernels to remove
if [ -z "$kernels_to_remove" ]; then
    echo "No old kernels found to remove."
    exit 0
fi

# Display kernels that will be removed
echo "The following kernels will be removed:"
echo "$kernels_to_remove"

to_remove="$kernels_to_remove"

# Confirm with user
read -p "Do you want to proceed with removal? (y/n): " confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
    echo "Operation cancelled."
    exit 0
fi

# Remove each kernel
for kernel in $kernels_to_remove; do
    # Also remove corresponding headers
    header_package="${kernel/image/headers}"
    if dpkg --list | grep -q "$header_package"; then
       to_remove = "$to_remove $header_package"
    fi
done

echo "Removing $to_remove"
apt-get purge -y $to_remove

echo "Kernel cleanup complete!"
