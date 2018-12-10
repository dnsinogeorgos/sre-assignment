# Security group configuration
# Common traffic rules
resource "aws_security_group" "all" {
  name = "allow_common"
  vpc_id = "${aws_vpc.workable_vpc.id}"

  # Allow inbound SSH traffic
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = "${var.ssh_clients_cidr}"
  }

  # Allow outbound instance traffic
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

# Access to the clusters should be routed internally
# Mongod and Redis are configured to use their subnet addresses
# Mongo traffic rules
resource "aws_security_group" "mongo" {
  name = "allow_mongo"
  vpc_id = "${aws_vpc.workable_vpc.id}"

  # Allow inbound mongod traffic
  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["${var.mongo_clients_cidr}"]
  }

  # Allow inbound mongod traffic from the cluster subnet
  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["${aws_subnet.mongo_sub.cidr_block}"]
  }
}

# Redis traffic rules
resource "aws_security_group" "redis" {
  name = "allow_redis"
  vpc_id = "${aws_vpc.workable_vpc.id}"

  # Allow inbound redis traffic
  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["${var.redis_clients_cidr}"]
  }

  # Allow inbound redis traffic from the cluster subnet
  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["${aws_subnet.redis_sub.cidr_block}"]
  }

  ingress {
    from_port   = 16379
    to_port     = 16379
    protocol    = "tcp"
    cidr_blocks = ["${aws_subnet.redis_sub.cidr_block}"]
  }
}
