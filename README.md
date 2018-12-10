# Workable SRE assignment

Simple configuration to deploy a replicated MongoDB cluster and a Redis
cluster on AWS free-tier.

The tools used are Terraform 0.11.10 and Ansible 2.7.4.

### Requisites:

To deploy the project you will need an AWS access/secret key pair and an
ssh-key loaded to your ssh-agent `ssh-add <path to your key>`.

`ansible-playbook` command must be available in `$PATH`.

You might want to create a valid `terraform.tfvars` file to change the
defaults and avoid being prompted for credentials. If, for example, you want
access to the mongo and/or redis ports from your premises, you will need to
change the `mongo_clients_cidr` and/or the `redis_clients_cidr`
variable. Available variables are explained through comments in the
`variables.tf` file.

Example `terraform.tfvars` file:
```hcl-terraform
access_key_id = "XXX"
secret_access_key = "XXXXXXXXXXXXXX"

ssh_keyname = "my-ssh-key"
ssh_pubkey_file = "~/.ssh/id_rsa.pub"

region = "eu-central-1"
aws_vpc_cidr = "172.19.0.0/16"
ssh_clients_cidr = ["0.0.0.0/0"]

mongo_cluster_size = "3"
mongo_replsetname = "rs0"
mongo_clients_cidr = ["172.19.10.0/24"]

redis_masters = "3"
redis_replicas = "1"
redis_clients_cidr = ["172.19.11.0/24"]
```

### Usage:

From the projects root folder, execute `terraform init` to install the
necessary providers and then `terraform apply` to deploy the project.

You will be prompted for the AWS access/secret key pair and the path to your
public key.

Upon successful deployment, the internal and public IP addresses of the
instances will be printed in the terminal.
