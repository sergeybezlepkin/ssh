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
<<<<<<< HEAD
	
read -p "Change the standard port (22) to the specified one? (y/n) " yn
	if [[ "${yn}" =~ ^(y|yes)$ ]]; then
		read -p "Enter password for $user@$ip: " paswd
		echo ""
		while true; do
		read -p "Enter port (49152-65535) " port
		if [[ "${port}" =~ ^[0-9]+$ ]] && [ "$port" -ge 49152 ] && [ "$port" -le 65535 ]; then
			echo "Attempting to change port to $port"
			ssh "$user@$ip" "PASWD=\"$paswd\" PORT=\"$port\" bash -s" << 'EOF'
			
			PASWD="$PASWD"
			PORT="$PORT"
			
			do_sudo() {
                    	echo "$PASWD" | sudo -S bash -c "$1"
			}
                
			do_sudo "sed -i '/^#\?Port/d' /etc/ssh/sshd_config && echo 'Port $PORT' >>/etc/ssh/sshd_config"
			
			if systemctl is-active --quiet firewalld; then
				do_sudo "firewall-cmd --permanent --remove-service=ssh 2>/dev/null && firewall-cmd --permanent --add-port=$PORT/tcp && firewall-cmd --reload"
			else
				if do_sudo "iptables -L -n | grep -q 'tcp dpt:22'"; then
					do_sudo "iptables -D INPUT -p tcp --dport 22 -j ACCEPT 2>/dev/null && iptables -A INPUT -p tcp --dport $PORT -j ACCEPT"
				fi
			fi
			
			do_sudo "systemctl restart sshd"
EOF
			break
		else
			echo "Invalid port. Please enter a number between 49152 and 65535"
		fi
		done
	else
		echo "Skipping the port change"
	fi

echo
echo "Clearing a variable with a password"
unset paswd

sleep 1
echo

read -p "Do you want to create a configuration file for a quick connection to the server? For example, enter ssh my-server in the terminal (y/n) " yn
if [[ "${yn}" =~ ^(y|yes)$ ]]; then
	if [ ! -f "$HOME/.ssh/config" ]; then
		touch "$HOME/.ssh/config"
		chmod 600 "$HOME/.ssh/config"
	fi
	
	while true; do
	read -p "Enter a short name for the connection (my-server) " nameserver
		if [[ "${nameserver}" =~ ^[a-zA-Z0-9-]+$ ]]; then
			echo "Your name to fast connection: $nameserver"
			break
		else
			echo "Invalid name. Try again"
		fi
	done

	if [[ -n $port ]]; then
		echo -e "\nHost $nameserver\n    HostName $ip\n    User $user\n    Port $port" >> "$HOME/.ssh/config"
		echo "To quickly connect, enter ssh $nameserver in the terminal"
		sleep 2
	else
		echo -e "\nHost $nameserver\n    HostName $ip\n    User $user\n    Port 22" >> "$HOME/.ssh/config"
		echo "To quickly connect, enter ssh $nameserver in the terminal"
		sleep 2
	fi
else
	echo "Skipping the config fast connection"
fi

echo
echo "SSH setup completed"
=======

echo "SSH setup completed"
>>>>>>> 31ff1448a8ecb0829adea389419675ecf869eaf2
