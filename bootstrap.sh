#!/bin/bash

# This script is used to clone the repository, initialize the variables, and run the playbook

# Clone the repository
git clone https://github.com/rishavnandi/ansible_homelab.git && cd ansible_homelab

# Read user input
read -p "Enter username: " username
read -p "Enter puid of the user: " puid
read -p "Enter pgid of the user: " pgid
read -p "Enter timezone: " timezone
read -p "Enter password for wireguard: " wg_password
read -p "Enter password for codeserver: " codeserver_password
read -p "Enter server IP address: " server_ip
read -p "Are you using a password instead of SSH keys? [y/n]: " use_password
read -p "Enter the domain name: " domain_name
read -p "Enter the Cloudflare email for traefik: " cloudflare_email
read -p "Enter the Cloudflare API key for traefik: " cloudflare_api_key
read -p "Enter jwt secret for authelia: " jwt_secret
read -p "Enter encryption key for authelia sqlite database: " encryption_key
read -p "Enter gmail address for authelia smtp: " gmail_address
read -p "Enter gmail insecure app password for authelia smtp: " gmail_password
read -p "Enter email for authelia admin: " admin_email
read -p "Enter argon2id password hash for authelia admin: " admin_password

# Replace values in vars.yml file
sed -i "s/<username>/$username/g" group_vars/all/vars.yml
sed -i "s#<timezone>#$timezone#g" group_vars/all/vars.yml
sed -i "s/<wg_pass>/$wg_password/g" group_vars/all/vars.yml
sed -i "s/<code_pass>/$codeserver_password/g" group_vars/all/vars.yml
sed -i "s/<server_ip>/$server_ip/g" group_vars/all/vars.yml
sed -i "s/<puid>/$puid/g" group_vars/all/vars.yml
sed -i "s/<pgid>/$pgid/g" group_vars/all/vars.yml
sed -i "s/<domain_name>/$domain_name/g" group_vars/all/vars.yml
sed -i "s/<cloudflare_email>/$cloudflare_email/g" group_vars/all/vars.yml
sed -i "s/<cloudflare_api_key>/$cloudflare_api_key/g" group_vars/all/vars.yml
sed -i "s/<jwt_secret>/$jwt_secret/g" group_vars/all/vars.yml
sed -i "s/<authelia_sqlite_encryption_key>/$encryption_key/g" group_vars/all/vars.yml
sed -i "s/<google_email>/$gmail_address/g" group_vars/all/vars.yml
sed -i "s/<google_insecure_app_pass>/$gmail_password/g" group_vars/all/vars.yml
sed -i "s/<authelia_admin_mail>/$admin_email/g" group_vars/all/vars.yml
sed -i "s/<authelia_admin_argon2id_pass>/$admin_password/g" group_vars/all/vars.yml

# Replace values in inventory file
sed -i "s/<server_ip>/$server_ip/g" inventory
sed -i "s/<username>/$username/g" inventory

if [ "$use_password" == "y" ]; then
  read -p "Enter SSH password: " ssh_password
  echo ""
  sed -i "s#ansible_ssh_private_key_file = <path/to/private/key>##g" inventory
  echo "ansible_ssh_pass = $ssh_password" >> inventory
else
  read -p "Enter path to private key: " private_key_path
  sed -i "s#<path/to/private/key>#$private_key_path#g" inventory
fi

# Run the playbook
ansible-playbook main.yml