vpn_file ?= wg0-client.conf
client ?= wg0-client

start-vpn:
	sudo wg-quick up $(client)
stop-vpn:
	sudo wg-quick down $(client)
setup-client:
	sudo apt update && sudo apt install wireguard
	sudo cp ~/Desktop/$(vpn_file) /etc/wireguard/$(vpn_file)
build:
	cd terraform/network && terraform init && terraform apply
	cd terraform && terraform init && terraform apply
	bash update-ansiblehosts.sh
	sleep 10
	cd ansible && ansible-playbook -i ansible_hosts_automated playbooks/wireguard.yml --ask-vault-password
destroy:
	cd terraform && terraform destroy --auto-approve
	cd terraform/network && terraform destroy --auto-approve
gen_qrcode:
	qrencode -t ansiutf8 < ~/Desktop/$(vpn_file)