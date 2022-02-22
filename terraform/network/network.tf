terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

# Set the variable value in *.tfvars file
# or using -var="do_token=..." CLI option
variable "do_token" {
  type = string
  description = "api token for digital ocean"
}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = var.do_token
}

# create floating ip for the vpn server
resource "digitalocean_floating_ip" "wireguard_ip" {
  region     = "tor1"
}

output "wireguard_ip" {
  value = digitalocean_floating_ip.wireguard_ip.ip_address
}