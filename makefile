start:
	sudo wg-quick up wg0-client
stop:
	sudo wg-quick down wg0-client
setup-client:
	sudo apt update && sudo apt install wireguard
	sudo cp ~/Desktop/wg0-client.conf /etc/wireguard/
