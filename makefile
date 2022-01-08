start-vpn:
	sudo wg-quick up wg0-client
stop-vpn:
	sudo wg-quick down wg0-client
setup-client:
	sudo apt update && sudo apt install wireguard
	sudo cp ~/Desktop/wg0-client.conf /etc/wireguard/
build:
	cd terraform/network && terraform init && terraform apply
	cd terraform && terraform init && terraform apply
	bash update-ansiblehosts.sh
	cd ansible && ansible-playbook -i ansible_hosts_automated playbooks/wireguard.yml --ask-vault-password
destroy:
	cd terraform && terraform destroy --auto-approve
	cd terraform/network && terraform destroy --auto-approve