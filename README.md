# terraform-ansible-flask-helloworld

An example repository for deploying a simple Flask + Apache app with Ansible on a GCP (Google Cloud Platform) compute instance provisioned with Terraform.

You can let Terraform provision a VM for you, or you can run the playbook on a manually created VM.

## Terraform steps

1. Create a GCP project
2. Create a service account with the Project>Editor role
3. Create and download a key for the service account
4. Enable Compute Engine API
5. The `/ansible/vars` directory has files that define the variables used for what the Ansible playbook will do, change them to suit your needs.
6. `cd` into the terraform directory
7. Make a copy of `example_terraform.tfvars`, rename it to `terraform.tfvars`, and fill in the variables for your setup.
9. Run `terraform init`
10. Run `terraform apply`
11. Type `yes` and hit enter
12. If everything goes well, Terraform will output the VM ip address which you can put in your browser to visit the website.
13. Run `terraform destroy` to destroy the provisioned resources.

## Ansible steps
You only need to follow these steps if you have manually created a VM. If you are using Terraform to provision a VM, Terraform will also run the Ansible playbooks for you.

Before you run the playbook you might want to manually run `apt update && apt upgrade` (and then reboot if needed) on the machine to upgrade the existing packages.

### Variables
1. Put the ip of your server in the `/ansible/inventory/hosts`, or point ansible to a different inventory file.
2. The `/ansible/vars` directory has files that define the variables used.

### Running the playbooks 
1. Run `ansible-playbook initial_server_setup.yml -u root` (from the ansible directory, as root because we haven't created the ansible user on the remote machine yet)
2. Run `ansible-playbook main.yml` (from the ansible directory)
3. Visit your server ip in your browser, it should now show "Hello, World!"

### SSH Agent Forwarding
If you are trying to clone a private repository, you will need to do some extra work. One option is to use SSH Agent Forwarding to allow the VM to use your local SSH key to clone the repo. 

To do this:
1. Run `eval "$(ssh-agent -s)"; ssh-add` to add your key to the ssh-agent.
2.  Open or create `~/.ssh/config`
3.  Enter the following text into the file, replacing `example.com` with your server's domain name or IP:

```plaintext
Host example.com
  ForwardAgent yes
```

Some more steps than just this will be required, but this should be a decent starting point to getting it working with a private repo.
