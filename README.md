# Ansible homelab

Ansible playbooks to quickly setup a homelab. These playbooks are designed to be run on a fresh install of Ubuntu 20.04.
The playbook will update the system, install docker, and then run the docker containers.

## Usage

- Clone the repo to your local machine

```bash
git clone https://github.com/rishavnandi/ansible_homelab.git
```

- Update the inventory file with the IP address of your server and the user you want to use to connect to the server
- Also update the `group_vars/vars.yml` file with the correct variables for your setup
- Run the playbook

```bash
ansible-playbook run.yml
```

## Removing unwanted apps

If you don't want to run some of the apps, you can easily remove them from the `run.yml` file since all the containers are stored as tasks in the tasks folder and are included in the `run.yml` file.
