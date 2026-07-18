variable "environment" {
  description = "Environment name"
  type        = string
}

variable "db_password" {
  description = "Postgres password"
  type        = string
  sensitive   = true
}

variable "api_image" {
  description = "API image"
  type        = string
  default     = "hashicorp/http-echo:1.0"
}

variable "nginx_image" {
  type    = string
  default = "nginx:latest"
}

variable "postgres_image" {
  type    = string
  default = "postgres:16"
}

variable "nginx_external_port" {
  description = "Host port for the nginx container"
  type        = number
  default     = 8080
}