Porter
---

### A ruby gem to allow simple IP Tables port forwarding from the command line

## Prepare your system

### First things first

You need to set your IP Tables to have a default drop policy.  **Be sure to allow SSH access first or you could lock yourself out!**

Allow your SSH access first if you don't have a screen and keyboard to use:

    $ iptables -A INPUT -p tcp -m tcp --dport 22 -j ACCEPT
    $ iptables -A OUTPUT -p tcp -m tcp --sport 22 -j ACCEPT
    
Now you need to set the default policy to drop:

    $ iptables -P INPUT DROP
    $ iptables -P OUTPUT DROP
    
This will lock everything down so only the ports you tell porter to open and your SSH port will be accessible.

### Preparing porter

You will need to setup your system first so porter knows which interface to accept forwards from and which interfaces it is allowed to forward over.

This is done by specifying a red and a green device:
* The red should be the external interface and accepts traffic on various ports
* The green interface(s) are allowed to have traffic forwarded over them

So you can make it so any traffic coming into the red interface on port 222 is forwarded to port 22 of a server on a green interface.

To configure a red (ppp0) and single green interface (eth0) you would do the following command:

    $ porter -p ppp0 eth0

It is possible to specify multiple green interfaces if you want to port forward to machines on the local network and a VPN for instance:

    $ porter -p eth1 eth0,tun0

## Forward a port

Say you want to make any traffic coming into the red interface on port 222 go to port 22 of a server (10.1.1.254) on a green interface.  You would issue the following command:

    $ porter -a 222 10.1.1.254 22
    
Or you want to allow clients to connect to an OpenVPN server inside the network over UDP, but using a non-standard port on the outside:

    $ porter -a u9944 10.1.1.250 1194
    
## Unforward a port

You can remove a port forward by specifying the port that is forwarded:

    $ porter -d 80
    $ porter -d u9945
    
## Get porter status

You can see all the port forwards on the machine by doing this:

    $ porter -l
    Red Port    Green Host     Green Port
    222         10.0.0.254     22
    u9944       10.0.0.250     1194
    u9945       10.0.0.251     1194
    80          10.0.0.254     8080
    2245        10.0.0.100     22

You can see which interfaces are which by doing this:

    $ porter -i
    Red interface:         ppp0
    Green interface(s):    eth1,tun1
    
Or do `porter` by itself to get both:

    $ porter
    Red interface:         ppp0
    Green interface(s):    eth1,tun1
    Red Port    Green Host     Green Port
    222         10.0.0.254     22
    u9944       10.0.0.250     1194
    u9945       10.0.0.251     1194
    80          10.0.0.254     8080
    2245        10.0.0.100     22
