# Network configuration
resource "aws_vpc" "workable_vpc" {
  cidr_block = "${var.aws_vpc_cidr}"
}

resource "aws_internet_gateway" "workable_gw" {
  vpc_id = "${aws_vpc.workable_vpc.id}"
}

resource "aws_route" "workable_default_route" {
  route_table_id = "${aws_vpc.workable_vpc.default_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.workable_gw.id}"
}

resource "aws_subnet" "mongo_sub" {
  vpc_id     = "${aws_vpc.workable_vpc.id}"
  cidr_block = "${cidrsubnet(aws_vpc.workable_vpc.cidr_block, 8, 0)}"
  map_public_ip_on_launch = "true"
}

resource "aws_subnet" "redis_sub" {
  vpc_id     = "${aws_vpc.workable_vpc.id}"
  cidr_block = "${cidrsubnet(aws_vpc.workable_vpc.cidr_block, 8, 1)}"
  map_public_ip_on_launch = "true"
}
