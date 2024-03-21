terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_credentials
}

# try playing and see template here in /v2/apps

resource "digitalocean_app" "bento_app" {
  spec {
    name   = "bento-app-spec-terraform"
    region = "sgp"

    env {
      key   = "AWS_ACCESS_KEY_ID"
      value = var.s3_access
      type  = "SECRET"
    }
    env {
      key   = "AWS_SECRET_ACCESS_KEY"
      value = var.s3_secret_access
      type  = "SECRET"
    }
    env {
      key   = "URL"
      value = var.mlflow_url
      type  = "GENERAL"
    }

    alert {
      rule = "DEPLOYMENT_FAILED"
    }

    service {
      name = "bento-service-image"
      image {
        registry_type = "DOCR"
        repository    = "c6prhswwdw76lc4z"
        tag           = "latest"
        deploy_on_push {
          enabled = true
        }
      }

      http_port          = 8080
      instance_size_slug = "basic-s"
      instance_count     = 1
    }
  }
}