# Ansible homelab

Ansible playbooks to quickly setup a homelab. These playbooks are designed to be run on a fresh install of Ubuntu 20.04/22.04.
The playbook will update the system, install Docker, and then deploy the Docker containers.

## Usage

- Clone the repo to your local machine

```bash
git clone https://github.com/rishavnandi/ansible_homelab.git
```

- Update the inventory file with the IP address of your server and the user you want to use to connect to the server and add the path to your ssh key, incase you are not using ssh keys (you should always use ssh keys for security) then you can replace the `ansible_ssh_private_key_file` with `ansible_ssh_pass` and add the password for the user. 

- Also update the `group_vars/vars.yml` file with the correct variables for your setup, for the pgid and puid, you can find the correct values by running the `id` command on your server and using the values for the `uid` and `gid` fields.

- Run the playbook

```bash
ansible-playbook run.yml -K
```

## Removing unwanted apps

If you don't want to run some of the apps, you can easily remove them from the `run.yml` file since all the containers are stored as tasks in the tasks folder and are included in the `run.yml` file.