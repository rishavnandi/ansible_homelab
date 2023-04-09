#!/usr/bin/env python3

import os
import subprocess

# Clone the repository
subprocess.run(
    ['git', 'clone', 'https://github.com/rishavnandi/ansible_homelab.git'])
os.chdir('ansible_homelab')

# Read user input
username = input("Enter username: ")
puid = input("Enter puid of the user: ")
pgid = input("Enter pgid of the user: ")
timezone = input("Enter timezone: ")
wg_password = input("Enter password for wireguard: ")
codeserver_password = input("Enter password for codeserver: ")
server_ip = input("Enter server IP address: ")
use_password = input("Are you using a password instead of SSH keys? [y/n]: ")
domain_name = input("Enter the domain name: ")
cloudflare_email = input("Enter the Cloudflare email for traefik: ")
cloudflare_api_key = input("Enter the Cloudflare API key for traefik: ")
traefik_user_hash = input("Enter traefik dashboard user hash: ")
jwt_secret = input("Enter jwt secret for authelia: ")
encryption_key = input("Enter encryption key for authelia sqlite database: ")
gmail_address = input("Enter gmail address for authelia smtp: ")
gmail_password = input("Enter gmail insecure app password for authelia smtp: ")
admin_email = input("Enter email for authelia admin: ")
admin_password = input("Enter argon2id password hash for authelia admin: ")

# Replace values in vars.yml file
with open('group_vars/all/vars.yml', 'r') as f:
    content = f.read()
content = content.replace('<username>', username)
content = content.replace('<timezone>', timezone)
content = content.replace('<wg_pass>', wg_password)
content = content.replace('<code_pass>', codeserver_password)
content = content.replace('<server_ip>', server_ip)
content = content.replace('<puid>', puid)
content = content.replace('<pgid>', pgid)
content = content.replace('<domain_name>', domain_name)
content = content.replace('<cloudflare_email>', cloudflare_email)
content = content.replace('<cloudflare_api_key>', cloudflare_api_key)
content = content.replace('<traefik_basic_auth_hash>', traefik_user_hash)
content = content.replace('<jwt_secret>', jwt_secret)
content = content.replace('<authelia_sqlite_encryption_key>', encryption_key)
content = content.replace('<google_email>', gmail_address)
content = content.replace('<google_insecure_app_pass>', gmail_password)
content = content.replace('<authelia_admin_mail>', admin_email)
content = content.replace('<authelia_admin_argon2id_pass>', admin_password)
with open('group_vars/all/vars.yml', 'w') as f:
    f.write(content)

# Replace values in inventory file
with open('inventory', 'r') as f:
    content = f.read()
content = content.replace('<server_ip>', server_ip)
content = content.replace('<username>', username)
if use_password == 'y':
    ssh_password = input("Enter SSH password: ")
    content = content.replace(
        'ansible_ssh_private_key_file = <path/to/private/key>', '')
    content += f'ansible_ssh_pass = {ssh_password}\n'
else:
    private_key_path = input("Enter path to private key: ")
    content = content.replace('<path/to/private/key>', private_key_path)
with open('inventory', 'w') as f:
    f.write(content)

# Run the playbook
subprocess.run(['ansible-playbook', 'main.yml'])
