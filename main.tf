# Provider credentials and region
provider "aws" {
  access_key = "${var.access_key_id}"
  secret_key = "${var.secret_access_key}"
  region     = "${var.region}"
}

# Key pair to be deployed to instances
resource "aws_key_pair" "keypair" {
  key_name   = "${var.ssh_keyname}"
  public_key = "${file("${var.ssh_pubkey_file}")}"
}
