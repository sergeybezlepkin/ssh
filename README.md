# Setting up access to a node by creating and adding a public key 

<div align="center">
  <img src="/docs/SSH.png" width="50%" /> 
</div>

[OpenSSH](https://www.openssh.org/) is the premier connectivity tool for remote login with the SSH protocol. It encrypts all traffic to eliminate eavesdropping, connection hijacking, and other attacks. In addition, OpenSSH provides a large suite of secure tunneling capabilities, several authentication methods, and sophisticated configuration options. 

##

#### Demonstration of the script running between local and remote nodes
<div align="center">
  <img src="/docs/ssh-DEMO.gif" /> 
</div>

##

### What does the project do? 

This project will configure access to the server via a public access key, disable password entry for access to the server, and can change the standard port of the SSH service to a specified one.

## What problem does it solve?

Launching a server in a production environment or running a rented remote server always raises security concerns. Password protection is the first level of security and doesn't require any special server configuration. However, there's a second level of server security—access via a cryptographic file (key), which requires special configuration, and the project will handle it for you

## Installation

### Windows

- You need to [install Git](https://git-scm.com/install/windows)
- Launching Git Bash in the system
- Run the command in the terminal
