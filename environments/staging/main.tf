terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 4.5"
    }

     local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

provider "docker" {}
provider "local" {}
module "app" {

  source = "../../modules/app"

  environment = "staging"

  db_password = var.db_password

  nginx_external_port = 8085

}