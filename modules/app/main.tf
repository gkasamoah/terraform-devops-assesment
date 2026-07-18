terraform {
  required_version = ">= 1.11"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 4.5"
    }
  }
}

resource "docker_volume" "postgres_data" {
  name = "${var.environment}-postgres-data"
}


resource "docker_network" "edge" {
  name = "${var.environment}-edge"
}

resource "docker_network" "internal" {
  name = "${var.environment}-internal"
}

resource "docker_network" "database" {
  name = "${var.environment}-database"
}

resource "docker_image" "postgres" {
  name = var.postgres_image
}

resource "docker_container" "postgres" {
  name  = "${var.environment}-postgres"
  image = docker_image.postgres.image_id

  env = [
    "POSTGRES_USER=appuser",
    "POSTGRES_PASSWORD=${var.db_password}",
    "POSTGRES_DB=appdb"
  ]

  mounts {
    target = "/var/lib/postgresql/data"
    source = docker_volume.postgres_data.name
    type   = "volume"
  }

  networks_advanced {
    name = docker_network.database.name
  }

  restart = "unless-stopped"
}

resource "docker_image" "api" {
  name = var.api_image
}

resource "docker_container" "api" {

  name = "${var.environment}-api"

  image = docker_image.api.image_id

  command = [
    "-text=Hello from ${var.environment}"
  ]

  networks_advanced {
    name = docker_network.internal.name
  }

  networks_advanced {
    name = docker_network.database.name
  }

  restart = "unless-stopped"
}
resource "local_file" "nginx_config" {

  filename = "${path.module}/generated-${var.environment}.conf"

  content = templatefile(
    "${path.module}/templates/nginx.conf.tftpl",
    {
      api_name = "${var.environment}-api"
    }
  )
}

resource "docker_container" "nginx" {

  name = "${var.environment}-nginx"

  image = docker_image.nginx.image_id

  ports {
    internal = 80
    external = var.environment == "staging" ? var.nginx_external_port : 8081
  }

  mounts {
    target = "/etc/nginx/conf.d/default.conf"
    source = abspath(local_file.nginx_config.filename)
    type   = "bind"
  }

  networks_advanced {
    name = docker_network.edge.name
  }

  networks_advanced {
    name = docker_network.internal.name
  }

  restart = "unless-stopped"

  depends_on = [
    docker_container.api
  ]
}
resource "docker_image" "nginx" {
  name = var.nginx_image
}