# Ansible homelab

Ansible playbooks to quickly setup a homelab. These playbooks are designed to be run on a fresh install of Ubuntu/Debian or RedHat based distros (Fedora, CentOS).
The playbook will update the system, install Docker, and then deploy the Docker containers.

## Bootstrap script

I have included a bootstrap script that clones the repo, asks the user for the username and IP address of the server, and then runs the playbook. You can run the script like this:

```bash
wget https://raw.githubusercontent.com/rishavnandi/ansible_homelab/master/bootstrap.py -o bootstrap.py && python3 bootstrap.py
```

## Using Treafik as a reverse proxy

I have finally switched from using nginx proxy manager to using Traefik as a reverse proxy. I have included a playbook to install Traefik and configure it to work with the apps.

For traefik to pull certificates I use cloudflare, so you will need to create a cloudflare account and add your domain to it. You will also need to create an API token in cloudflare and add it to the `group_vars/vars.yml` file.

For the traefik user basic auth, I use a password hash, you can generate a password hash using the `htpasswd` command, for example:

```bash
echo $(htpasswd -nB <USER>) | sed -e s/\\$/\\$\\$/g
```

It will prompt you for a password, enter the password and it will output the password hash, copy the output and remove any double `$` characters as they are only needed when using it directly in a docker compose file. Then add the password hash to the `group_vars/vars.yml` file.

## Using Authelia as a second factor authentication

I have also added support for Authelia, which is a second factor authentication service. There are many variables that need to be set for Authelia to work, since I also use the google smtp server to send password reset emails.

- jwt_secret: Needs to be a random string upto 64 characters I believe
- sqlite_encryption_key: Needs to be a random string atleast 20 characters
- google_mail_id: Of the account which will be used to send the password reset emails
- google_insecure_app_password: You will need to generate an insecure app password for authelia to use, check more details in [Authelia docs](https://www.authelia.com/configuration/notifications/smtp/)
- authelia_admin_mail: email of the authelia admin user
- authelia_admin_argon2id: argon2id hash of the password for admin user, see how to generate one in the [Authelia docs](https://www.authelia.com/reference/guides/passwords/)

## Blog post

I have written a blog post about this repo, you can find it here: [https://www.rishavnandi.com/posts/Ansible_homelab](https://www.rishavnandi.com/posts/Ansible_homelab)

## Usage

- Clone the repo to your local machine

```bash
git clone https://github.com/rishavnandi/ansible_homelab.git
```

- Update the inventory file with the IP address of your server and the user you want to use to connect to the server and add the path to your ssh key, incase you are not using ssh keys (you should always use ssh keys for security) then you can replace the `ansible_ssh_private_key_file` with `ansible_ssh_pass` and add the password for the user. 

- Also update the `group_vars/vars.yml` file with the correct variables for your setup, for the pgid and puid, you can find the correct values by running the `id` command on your server and using the values for the `uid` and `gid` fields.

- Run the playbook

```bash
ansible-playbook main.yml
```

You'll notice that for most apps the ports are not exposed, as I prefer exposing only the neccessary ports and for the rest I add them to a custom Docker network and then use nginx proxy manager to access the apps, a benefit of putting all the containers on a custom Docker network is that you can reference them in nginx proxy manager using their container name instead of the IP address, which makes it easier to manage.

## Removing unwanted apps

If you don't want to run some of the apps, you can easily remove them from the `main.yml` file since all the containers are stored as tasks in the tasks folder and are included in the `main.yml` file.

## Info about the apps

If you want to learn more about any of the apps, you can check out the [awesome selfhosted repo](https://github.com/awesome-selfhosted/awesome-selfhosted).

## Included Terraform script

I have included a Terraform script that I use to quickly spin up an AWS instance to run the playbook on. You can use this script to spin up an instance, or you can use it as a reference to create your own Terraform script.
You can find more info about using Terraform with AWS here: [https://learn.hashicorp.com/tutorials/terraform/aws-build](https://learn.hashicorp.com/tutorials/terraform/aws-build)

## Goals

- [x] Add support for Ubuntu 22.04
- [x] Add support for Debian 11
- [x] Add support for RedHat based distros (Fedora, CentOS)
- [x] Find a permanent fix for the Docker install issue on Ubuntu 22.04

## Credits

- [Jeff Geerling](https://www.jeffgeerling.com/) for all the awesome Ansible content
- [linuxserver.io](https://linuxserver.io/) for the Docker containers
- [Ansible docs](https://docs.ansible.com/ansible/latest/) for the Ansible documentation
- [Wolfgang's infra repo](https://github.com/notthebee/infra) for the Docker install fix for Ubuntu 22.04
