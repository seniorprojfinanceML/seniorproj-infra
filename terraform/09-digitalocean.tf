# terraform {
#   required_providers {
#     digitalocean = {
#       source  = "digitalocean/digitalocean"
#       version = "~> 2.0"
#     }
#   }
# }

resource "digitalocean_app" "bento_app" {
  name = "bento-app"

  spec {
    name = "bento-app-spec"

    service {
      name              = "web"
      image {
        registry_type  = "PRIVATE"
        repository     = "registry.digitalocean.com/test-ml"
        tag            = "latest"
        deploy_on_push = "enabled"
      }

      http_port         = 8080
      instance_size_slug = "basic-s"
      instance_count     = 1
    }
  }
}