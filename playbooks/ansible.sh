#!/bin/bash
# Este script nos permite ejecutar los playbook en el bastion 
## Parametros esperados  POSICIONALES 
## 1 -  IP 
## 2 -  nodename
## 3 -  tipo de nodo 
#
mkdir -p /abel/.ssh/
cp -f /tmp/playbooks/files/key /home/abel/.ssh/id_rsa
chmod 700 /home/abel/.ssh/id_rsa
echo -e "[all]\n$1\n" >/tmp/playbooks/hosts
cd  /tmp/playbooks/
#export ANSIBLE_HOST_KEY_CHECKING=False && ansible-playbook -u abel -i hosts $2.yaml --extra-vars=\{\"nodes\":\[\{\"hostname\":\"master\",\"ip\":\"192.168.2.110\",\"box\":\"centos/8\",\"ram\":2000,\"dns\":\"master\ master.acme.es\"\},\{\"hostname\":\"worker01\",\"ip\":\"192.168.2.111\",\"box\":\"centos/8\",\"ram\":1000,\"dns\":\"worker01\ worker01.acme.es\"\},\{\"hostname\":\"worker02\",\"ip\":\"192.168.2.112\",\"box\":\"centos/8\",\"ram\":1000,\"dns\":\"worker02\ worker02.acme.es5\"\},\{\"hostname\":\"nfs\",\"ip\":\"192.168.2.115\",\"box\":\"centos/8\",\"ram\":1000,\"dns\":\"nfs\ nfs.acme.es\"\}\],\"node\":\"$2\",\"stage\":\"azure\"\}
export ANSIBLE_HOST_KEY_CHECKING=False && ansible-playbook -u abel -i hosts $3.yaml --extra-vars="node=$2 stage=azure"