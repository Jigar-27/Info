output "mysql_container_id" {
  value = docker_container.mysql.id
}

output "redis_container_id" {
  value = docker_container.redis.id
}

output "network_id" {
  value = docker_network.app_network.id
}
