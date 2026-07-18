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

  environment = "production"

  db_password = var.db_password

}