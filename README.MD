#  Basic ssh server with docker/podman
Hi this is my setup for sshing container. 

# Why? 

Purpose of this is using with `ssh` and `sshfs` and gaining  `vscode/dev-containers` functionality with any ide you desire.

# Warning
Keep in mind that this docker file built with no security in mind. Its assumed that your computer's or your modem's firewall already blocking this ports to the outside. If you want to use it in internal networks, please harden it.

# How to use it.
First, keep in mind that every time you started a new container, sshd key will change and ssh will warn you about it. You should remove `~/.ssh` everytime for a new container.

you build it `Dockerfile` with:
```
docker build -t alpine-ssh .
```
then run it with:
```
docker run -p 2222:22 -it alpine-ssh
```
then connect to ssh with your terminal(default password is `password`):
```
ssh -p 2222 ed@yourlocalipaddress
```
then mount user ed's home folder with(default password is `password`):
```
sshfs -oport=2222 ed@yourlocalipaddress:/home/ed /your/desired/mount/point
```
change your local ip address with inet section of your network interface when running `ip addr` for example if it shows:
```
inet 192.168.1.122/44 brd 192.168.1.255 scope global dynamic noprefixroute wlan0
```     
yourlocalipaddress should be 192.168.1.122.

After finished unmount with:
```
fusermount -u /your/desired/mount/point
```

# Gaining root privileges in container
`doas`(sudo replacement) is installed. For drop in root shell use:
```
doas su
```

# I want to change default user
Sure default user's username defined in "USERNAME" variable and default password is in "PASSWORD", you can either change it in `Dockerfile` or define as variable when building container.

