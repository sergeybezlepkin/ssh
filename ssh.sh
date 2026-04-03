#!/usr/bin/env bash

if [ ! -d "$HOME/.ssh" ]; then
    mkdir -p "$HOME/.ssh"
    chmod -R 700 "$HOME/.ssh"
fi
	
sleep 1
	
if [ -f /etc/os-release ]; then
	if [ ! -f "$HOME/.ssh/authorized_keys" ]; then
		touch "$HOME/.ssh/authorized_keys"
	fi
fi
	
sleep 1
echo

if [ ! -f "$HOME/.ssh/id_rsa" ]; then
    echo "Generating a new SSH key"
        if ssh-keygen -t rsa -N "" -f "$HOME/.ssh/id_rsa" -q; then
			echo "The key has been successfully created"
        else
			echo "Failed to create SSH key"
			sleep 5
            exit 1
        fi
    else
        echo "SSH key already exists"
fi
	
sleep 1
echo
	
while true; do
    read -p "Enter IPv4 address for node: " ip
        if [[ "$ip" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
			break
        else
            echo "Invalid IPv4 address. Try again"
        fi
done

sleep 1
echo

if ping $ip > /dev/null 2>&1; then
	echo "Node on $ip is accessible"
else
	echo "Node on $ip is unavailable"
	sleep 2
fi

sleep 1
echo

while true; do
    read -p "Enter username for node $ip: " user
        if [[ "$user" =~ ^[a-zA-Z_][a-zA-Z0-9_-]*$ ]]; then
            if [[ "$user" == "root" ]]; then
                echo "Warning: Using root user is unsafe"
            fi
			break
        else
            echo "Invalid username. Use Latin letters, numbers, '_', '-', and start with a letter"
        fi
done

sleep 1
echo

echo "Setting up SSH for node $ip with user $user"
if ssh-copy-id -i "$HOME/.ssh/id_rsa.pub" -o StrictHostKeyChecking=no "$user@$ip"; then
    echo "The key has been successfully copied to the node $ip"
else
    echo "Failed to copy SSH key to node $ip"
    sleep 5
    exit 1
fi

sleep 1
echo

read -p "Disable password authentication for the node $ip? (y/n) " yn
	if [[ "${yn}" =~ ^(y|yes)$ ]]; then
		echo "Connecting to $ip as $user to apply changes"
		ssh "$user@$ip" "sudo -S sed -i '/^#*PasswordAuthentication/d' /etc/ssh/sshd_config && echo 'PasswordAuthentication no' | sudo -S tee -a /etc/ssh/sshd_config && sudo systemctl restart sshd"
	else
		echo "Skipping disabling password authentication for the node $ip"
	fi

sleep 1
echo

echo "SSH setup completed"