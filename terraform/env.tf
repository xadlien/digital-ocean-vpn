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

# get remote state for networking info
data "terraform_remote_state" "network" {  
  backend = "local"
  config = {    
    path = "./network/terraform.tfstate"  
  }
}

# Create the vpn server
resource "digitalocean_droplet" "martin_vpn" {
    image  = "ubuntu-20-04-x64"
    name   = "martin-vpn01"
    region = "nyc3"
    size   = "s-2vcpu-4gb"
    ssh_keys = [32690924]
}

# assign the floating IP
resource "digitalocean_floating_ip_assignment" "open_vpn_assignment" {
  ip_address = data.terraform_remote_state.network.outputs.openvpn_ip
  droplet_id = digitalocean_droplet.martin_vpn.id
}

# create firewall
resource "digitalocean_firewall" "openvpn_firewall" {
  name = "openvpn-firewall"

  droplet_ids = [digitalocean_droplet.martin_vpn.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "51820"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol = "tcp"
    port_range = "1-25565"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}

# output ipv4 address
output "dev_instance_ip_addr" {
  value = digitalocean_droplet.martin_vpn.ipv4_address
}
