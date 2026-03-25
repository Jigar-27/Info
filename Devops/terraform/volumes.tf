resource "docker_volume" "mysql_data" {
  name = "terraform_mysql_data"
}

resource "docker_volume" "redis_data" {
  name = "terraform_redis_data"
}
