# Instance addresses, local and public
output "mongo_internal_ips" {
  value = "${aws_instance.mongo_instance.*.private_ip}"
}

output "mongo_public_ips" {
  value = "${aws_instance.mongo_instance.*.public_ip}"
}

output "redis_internal_ips" {
  value = "${aws_instance.redis_instance.*.private_ip}"
}

output "redis_public_ips" {
  value = "${aws_instance.redis_instance.*.public_ip}"
}
