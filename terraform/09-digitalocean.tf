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
# https://docs.digitalocean.com/reference/api/api-try-it-now/

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

resource "digitalocean_droplet" "miscellaneous_instance" {
  image      = "ubuntu-23-10-x64"
  name       = "ubuntu-s-2vcpu-4gb-sgp1-01-in-terraform-1"
  region     = "sgp1"
  size       = "s-2vcpu-4gb"
  monitoring = true
}

resource "digitalocean_firewall" "miscellaneous_instance_fw" {
  name = "instance-fw-terraform"

  droplet_ids = [
    digitalocean_droplet.miscellaneous_instance.id,
  ]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "6789"
    source_addresses = ["0.0.0.0/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "8501"
    source_addresses = ["0.0.0.0/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0"]
  }
}
