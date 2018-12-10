# Mongo instances
resource "aws_instance" "mongo_instance" {
  ami           = "${lookup(var.amis, var.region)}"
  instance_type = "t2.micro"
  count = "${var.mongo_cluster_size}"
  key_name = "${var.ssh_keyname}"
  subnet_id = "${aws_subnet.mongo_sub.id}"
  vpc_security_group_ids  = [
    "${aws_security_group.all.id}",
    "${aws_security_group.mongo.id}"
  ]

  root_block_device {
    delete_on_termination = "true"
  }

  # Need to successfully connect to instance before moving on to deployment
  provisioner "remote-exec" {
    inline = ["true"]

    connection {
      user        = "centos"
    }
  }
}

# Null resource triggered when all mongo instances are ready
resource "null_resource" "mongo_instances" {
  triggers {
    mongo_instance_ids = "${join(",", aws_instance.mongo_instance.*.id)}"
  }

  # Deploy required os changes and mongod
  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ${join(",", aws_instance.mongo_instance.*.public_ip)}, -e \"replsetname=${var.mongo_replsetname}\" -u centos ansible/mongo.yml"
  }

  # Initiate mongod cluster
  # A helper script is used to generate the json formated query
  provisioner "remote-exec" {
    inline = ["mongo_init ${join(" ", aws_instance.mongo_instance.*.private_ip)} --rsn ${var.mongo_replsetname} --host ${aws_instance.mongo_instance.0.private_ip}"]

    connection {
      host = "${aws_instance.mongo_instance.0.public_ip}"
      user = "centos"
    }
  }
}
