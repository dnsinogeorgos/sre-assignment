# AWS credentials
variable "access_key_id" {}
variable "secret_access_key" {}

# Name of your SSH key on AWS console
variable "ssh_keyname" {
  default = "deployer-key"
}

# Path to your public SSH key
variable "ssh_pubkey_file" {}

# Region to deploy to
variable "region" {
  default = "eu-west-2"
}

# A map of centos AMIs for europe regions
variable "amis" {
  type = "map"
  default = {
    "eu-central-1" = "ami-dd3c0f36"
    "eu-west-1" = "ami-3548444c"
    "eu-west-2" = "ami-00846a67"
    "eu-west-3" = "ami-262e9f5b"
  }
}

variable "aws_vpc_cidr" {
  default = "172.27.0.0/16"
}

# List of CIDRs to allow inbound SSH traffic from.
# Change this to your management network subnet(s).
variable "ssh_clients_cidr" {
  default = ["0.0.0.0/0"]
}

# Number of mongodb cluster members
variable "mongo_cluster_size" {
  default = "3"
}

# Name of your mongo cluster replicaSetName value
variable "mongo_replsetname" {
  default = "rs0"
}

# List of CIDRs to allow mongo traffic from.
# mongod processes will advertise internal addresses, access for management
# purposes is ok from external addresses but client redirection will only work
# with internally routed clients.
# Change this to your application server subnet(s).
variable "mongo_clients_cidr" {
  default = ["172.27.10.0/24"]
}

# Total number of instances will be masters * (replicas + 1)
# Number of redis masters.
variable "redis_masters" {
  default = "3"
}

# Number of redis replicas per master
variable "redis_replicas" {
  default = "1"
}

# List of CIDRs to allow redis traffic from.
# redis processes will advertise internal addresses, access for management
# purposes is ok from external addresses but client redirection will only work
# with internally routed clients.
# Change this to your application server subnet(s).
variable "redis_clients_cidr" {
  default = ["172.27.11.0/24"]
}
