terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 4.5"
    }
  }
}

provider "docker" {}

module "app" {

  source = "../../modules/app"

  environment = "staging"

  db_password = var.db_password

  nginx_external_port = 8085

}