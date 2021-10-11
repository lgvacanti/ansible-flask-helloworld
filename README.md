# ansible-flask-helloworld

An example repository for deploying a flask + apache app with Ansible.

Tested on a DigitalOcean droplet, Ubuntu 20.04

Before you run the playbook you might want to manually run `apt update && apt upgrade` (and then reboot if needed) on the machine to upgrade the existing packages.

## Variables
1. Put the ip of your server in the `/ansible/inventory/hosts`, or point ansible to a different inventory file.
2. The `/ansible/vars` directory has files that define the variables used.

## Running the playbooks 
1. Run `ansible-playbook initial_server_setup.yml -u root` (from the ansible directory, as root because we haven't created the ansible user on the remote machine yet)
2. Run `ansible-playbook main.yml` (from the ansible directory)
3. Visit your server ip in your browser, it should now show "Hello, World!"

## SSH Agent Forwarding
If you are trying to clone a private repository, you need to set up SSH Agent Forwarding, so the remote machine can use your key to clone the repo.

To do this:
1. Run `eval "$(ssh-agent -s)"; ssh-add` to add your key to the ssh-agent.
2.  Open or create `~/.ssh/config`
3.  Enter the following text into the file, replacing `example.com` with your server's domain name or IP:

```plaintext
Host example.com
  ForwardAgent yes
```