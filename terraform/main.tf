terraform {
  required_version = "~> 1.0"
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "~> 2.12"
    }
  }
}

variable "proxy_image" {
  type    = string
  default = "traefik:latest"
}

variable "proxy_config" {
  type    = string
  default = "traefik.yaml"
}

variable "proxy_command" {
  type    = list(string)
  default = [
    "--api.insecure=true",
    "--providers.file.filename=/config/traefik.yaml",
    "--entrypoints.web.address=:80",
    "--entrypoints.web.forwardedheaders.insecure=true",
  ]
}

variable "backend_image" {
  type    = string
  default = "traefik/whoami:latest"
}

locals {
  proxy_config  = var.proxy_config
  proxy_command = var.proxy_command
  images = {
    backend = var.backend_image
    proxy   = var.proxy_image
  }
}

resource docker_network "NETWORK" {
  name = "proxy-examples"
}

# Check image tag from registry
data docker_registry_image "IMAGE" {
  for_each = local.images
  name = each.value
}

# Download image matching monitored tag
resource docker_image "IMAGE" {
  for_each = local.images
  name = data.docker_registry_image.IMAGE[each.key].name
  pull_triggers = [data.docker_registry_image.IMAGE[each.key].sha256_digest]
}

# Create backend containers
resource docker_container "BACKEND" {
  for_each = toset(["demo-1","demo-2","demo-3"])
  name = each.key
  image = docker_image.IMAGE["backend"].latest
  networks_advanced {
    name = docker_network.NETWORK.name
    aliases = [each.key]
  }
}

resource docker_container "PROXY" {
  name = "proxy"
  image = docker_image.IMAGE["proxy"].latest
  command = local.proxy_command

  upload {
    file   = "/config/${local.proxy_config}"
    source = "${path.module}/../files/${local.proxy_config}"
  }
  
  networks_advanced {
    name = docker_network.NETWORK.name
  }

  ports {
    internal = 80
    external = 8080
  }
}
