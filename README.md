# Ansible homelab

Ansible playbooks to quickly setup a homelab. These playbooks are designed to be run on a fresh install of Ubuntu 20.04/22.04 and Debian 11.
The playbook will update the system, install Docker, and then deploy the Docker containers.

## Bootstrap script

I have included a bootstrap script that clones the repo, asks the user for the username and IP address of the server, and then runs the playbook. You can run the script like this:

```bash
curl https://raw.githubusercontent.com/rishavnandi/ansible_homelab/master/bootstrap.sh -o bootstrap.sh && bash bootstrap.sh
```

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

## Docker install issue on Ubuntu 22.04

If you are running Ubuntu 22.04, you might run into an issue where the Docker install fails. This is because of a dumb issue with Ubuntu 22.04 "Jammy" itself. The playbooks are designed to work around this issue, you just need to run the playbook twice. The first time it will fail, but it will have fixed the issue for the second run. I am working on a fix for this, but for now, this is the workaround.

```yaml
  rescue:
    - name: Fix the dumb Ubuntu Jammy error
      ansible.builtin.replace:
        path: /etc/systemd/system/multi-user.target.wants/docker.service
        regexp: "fd://"
        replace: "unix://"
      when: ansible_distribution == 'Ubuntu' and ansible_distribution_version is version('22.04', '>=')
```

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
- [ ] Add SSH hardening
- [ ] Find a permanent fix for the Docker install issue on Ubuntu 22.04
- [ ] Use Ansible to automate some more stuff so there is no need to enter the IP address and PUID/PGID manually
- [ ] Add support for Fedora
- [ ] Add more apps

## Credits

- [Jeff Geerling](https://www.jeffgeerling.com/) for all the awesome Ansible content
- [linuxserver.io](https://linuxserver.io/) for the Docker containers
- [Ansible docs](https://docs.ansible.com/ansible/latest/) for the Ansible documentation
- [Wolfgang's infra repo](https://github.com/notthebee/infra) for the Docker install fix for Ubuntu 22.04
