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

* Local machine running Windows, configuring it for a remote server running Linux

- Install [Git](https://git-scm.com/install/windows)
- Launch Git Bash
- Run a command in the terminal

  ```
  git clone https://github.com/sergeybezlepkin/ssh.git && cd ssh && ./ssh.sh
  ```

* Remote server running Linux, configuring it for a remote server running Linux

- Install [git](https://git-scm.com/install/linux)
- Run a command in the terminal

  ```
  git clone https://github.com/sergeybezlepkin/ssh.git && cd ssh && ./ssh.sh
  ```

## What actions does the script perform?

* Check for the presence of a hidden SSH service directory; if it doesn't exist, create it.
* Check for the presence of an authorized_keys file in the hidden SSH service directory; if it doesn't exist, create it.
* Check for the presence of an already created key; if it exists, skip the creation operation; if it doesn't exist, create it.
* Enter the IPv4 address of the remote node; The address will be checked for validity.
* Enter the username; The username will be checked for validity; If the user is root, a warning message will be displayed.
* Copy the key to the remote node; You will be prompted to enter the password for the provided user.
* You will be asked about changing the default SSH service port; You can confirm or skip this. After confirmation, you will be prompted to enter a password for this feature to work. Enter the port number. Depending on the system, a firewall rule will be applied.
* Clear the password from the buffer entered above.
* You will be asked about disabling access to the server via password entry. You can confirm or skip this.
* You will be asked whether to create a configuration file that will allow you to quickly log into the server. You can confirm or skip this. If you specified a new port, it will be used. If the port is not specified, the configuration uses port 22.

## License

This project uses the [MIT]()
