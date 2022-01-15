# DigitalOcean VPN
## Description
This repository holds the necessary code to initialize a VPN in digital ocean. The makefile can also setup your client machine to connect to the VPN. **I take no responsibility for any costs associated with this code. You will be billed for usage of digital ocean cloud.**
## Setup
### Update Some Values
There are two things that need to be checked before running.
1. Ensure that the ssh_keys value is your own ssh_key id from Digital Ocean.
2. After applying the terraform ensure you update the inventory with the IP address given.
3. Create your own certificates in the `ansible/group_vars/wireguard.yml` file.
#### Certificate Creation
Two packages are needed to create the necessary encrypted strings:
1. ansible
2. wireguard
```
# to create the certs and encrypt with ansible-vault
wg genkey | tee server_private.key | wg pubkey > server_public.key
wg genkey | tee client_private.key | wg pubkey > client_public.key
sed 's/\n//g' server_private.key | ansible-vault encrypt_string
sed 's/\n//g' server_public.key | ansible-vault encrypt_string
sed 's/\n//g' client_private.key | ansible-vault encrypt_string
sed 's/\n//g' client_public.key | ansible-vault encrypt_string

# then copy the output to the file in the corresponding variables.
```
### Create VPN Server
```
cd terraform/network
terraform init
terraform apply
cd ..
terraform init 
terraform apply
cd ..
```
### Setup Wireguard
```
cd ansible
ansible-playbook -i ansible_hosts playbooks/wireguard.yml --ask-vault-pass
```
## Cleanup
You will need to destroy the environment to stop being billed for the infrastructure. Run the following from the respository:
```
cd terraform
terraform destroy
cd network
terraform destroy
```
This will clean up all objects created in digital ocean.
## Automation
This process is automated in the makefile.
### Build Droplet and Install VPN
`make build`
### Setup Client Machine
`make setup-client`
### Start VPN on Client
`make start-vpn`
### Stop VPN on Client
`make stop-vpn`
### Delete Droplet and Other Infrastructure
`make destroy`