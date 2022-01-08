ip_addr=`sed -rn "s/.*([0-9]{3}\.[0-9]+\.[0-9]+\.[0-9]+).*/\1/p" terraform/network/terraform.tfstate | head -n1`
echo -e "[wireguard]\n${ip_addr}" > ansible/ansible_hosts_automated