resource "docker_image" "mysql" {
  name = "mysql:8.0"
}

resource "docker_container" "mysql" {
  name  = "terraform_mysql"
  image = docker_image.mysql.image_id

  env = [
    "MYSQL_DATABASE=laravel",
    "MYSQL_ROOT_PASSWORD=secret"
  ]

  volumes {
    volume_name    = docker_volume.mysql_data.name
    container_path = "/var/lib/mysql"
  }

  networks_advanced {
    name = docker_network.app_network.name
  }

  restart = "unless-stopped"
}
