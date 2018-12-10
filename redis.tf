# Redis instances
resource "aws_instance" "redis_instance" {
  ami           = "${lookup(var.amis, var.region)}"
  instance_type = "t2.micro"
  count = "${var.redis_masters * (var.redis_replicas + 1)}"
  key_name = "${var.ssh_keyname}"
  subnet_id = "${aws_subnet.redis_sub.id}"
  vpc_security_group_ids  = [
    "${aws_security_group.all.id}",
    "${aws_security_group.redis.id}"
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

# Null resource triggered when all redis instances are ready
resource "null_resource" "redis_instances" {
  triggers {
    redis_instance_ids = "${join(",", aws_instance.redis_instance.*.id)}"
  }

  # Deploy required os changes and redis
  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ${join(",", aws_instance.redis_instance.*.public_ip)}, -u centos ansible/redis.yml"
  }

  # Initiate redis cluster
  provisioner "remote-exec" {
    inline = ["echo yes | sudo redis-cli --cluster create ${join(" ", formatlist("%s:6379", aws_instance.redis_instance.*.private_ip))} --cluster-replicas ${var.redis_replicas}"]

    connection {
      host = "${aws_instance.redis_instance.0.public_ip}"
      user = "centos"
    }
  }
}
