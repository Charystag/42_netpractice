# Netpractice helper script

## Table of Contents

1. [What is this script about]
2. [How to use it?]
3. [IP addresses conversion]
4. [Subnet Masks conversion]
5. [IP addresses range computation]

# What is this script about ? 
The goal of this set of bash functions is to help someone that doesn't know how ip addressing
works to be more at ease with the basic computations. To do so, the basic computations that you'll have to realize why realizing the netpractice project are implemented.

# How to use it ?
To use this script, you'll have to clone the repository and run the command :
```bash
make
```
at the root of the repository. This will launch the script `main.sh` which will itself launch the main menu and allow you to use the different functionnalities.

# IP addresses conversion
One of the task that you'll have to do to realize the netpractice project is to convert IP addresses to analyse which bits are on and off in order to do computations to know on which networks/subnetwork they belong to.
The script is able to convert IP addresses from the following formats :
- Dotted decimal notation to dotted binary notation
- Dotted binary notation to dotted decimal notation

# Subnet Masks conversion
Another task that you'll have to do to realize the netpractice project is to convert subnet masks to analyse which bits are on and off in order to do computations to know the length of the subnet mask and the number of hosts that can be on the network.
The script is able to convert subnet masks from the following formats :
-CIDR notation to dotted binary notation
- Dotted binary notation to CIDR notation

# IP addresses range computation
The last task that you'll have to do to realize the netpractice project is to compute the range of IP addresses that can be on a network. To do so, you'll have to know an IP address and a subnet mask. The script is able to compute the range of IP addresses with IP and masks from the following formats :
-IP address:
    - Dotted decimal notation
    - Dotted binary notation
-Subnet mask:
    - Dotted decimal notation
    - Dotted binary notation
    - CIDR notation