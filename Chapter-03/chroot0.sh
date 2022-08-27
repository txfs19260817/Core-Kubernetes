# /bin/bash

# Makes our box with the bin and lib directories as dependencies for our Bash program
mkdir -p /home/namespace/box/bin
mkdir -p /home/namespace/box/lib
mkdir -p /home/namespace/box/lib64
mkdir -p /home/namespace/box/proc
mkdir /home/namespace/box/data

# Copies all the programs from our base OS into this box so we can run Bash in our root directory
cp -v /bin/bash /home/namespace/box/bin
cp -v /bin/ip /home/namespace/box/bin
cp -v /bin/ls /home/namespace/box/bin
cp -v /bin/mount /home/namespace/box/bin
cp -v /bin/umount /home/namespace/box/bin
cp -v /bin/kill /home/namespace/box/bin
cp -v /bin/ps /home/namespace/box/bin
cp -v /bin/curl /home/namespace/box/bin
cp -v /bin/pidof /home/namespace/box/bin
cp -v /bin/expr /home/namespace/box/bin
cp -v /bin/rm /home/namespace/box/bin

# Copies the library dependencies of these programs into the lib/ directories
cp -r /lib/* /home/namespace/box/lib/
cp -r /lib64/* /home/namespace/box/lib64/

# Mounts the /proc directory to this location
mount -t proc proc /home/namespace/box/proc
mount --bind -v /tmp/ /home/namespace/box/data

# This is the important part: we start our isolated Bash process in a sandboxed directory.

# Uncomment the command below (and comment commands below it) to start a /proc mounted isolated chroot jail
# unshare --pid --net --fork --mount-proc=/home/namespace/box/proc chroot /home/namespace/box /bin/bash

# To obtain the true PID of out unshared process, we need to manually mount /proc to obtain it, 
# otherwise the PID should be "1" due to its isolation.
unshare --mount --uts --ipc --net --pid --fork chroot /home/namespace/box /bin/bash

# Do the following command when entered our chroot jail

# echo "1. issue the below command to capture the bash's PID"
# expr $(pidof unshare) + 1
# echo "2. finally mount proc to isolate PIDs"
# mount --type proc none /proc
