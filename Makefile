export VAGRANT_EXPERIMENTAL="disks"
welcome: 
	echo "Bienvenidos"

setupSshKeyPair:
	ssh-keygen -b 2048 -t rsa -f terraform/files/key -q -N ""
checkReq:
	bash check_req.sh 
local  up:  checkReq
	vagrant up
local softwareInstall: checkReq
	vagrant provision
azuresetupCreds: 
	python loginazure.py

terraformPlan:
	cd terraform && terraform plan

terraformUp:
	cd terraform && terraform init && terraform apply

terraformDestroy:
	cd terraform &&  terraform destroy

appsReDeploy:
	cd terraform && terraform taint null_resource.apps && terraform apply

appsReDeploy produccion:
	cd terraform && terraform taint null_resource.apps && terraform apply  -var="AppEnvToDeploy=produccion"

appsReDeploy desarrollo:
	cd terraform && terraform taint null_resource.apps && terraform apply  -var="AppEnvToDeploy=desarrollo"
terraformRunPlaybooks:
	cd terraform && terraform taint null_resource.master null_resource.nfs null_resource.worker01 null_resource.worker02 && terraform apply
	