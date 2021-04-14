# K8S Nginx Workshop 

This is a workshop intended to understand k8s and how nginx ingress is installed and configured.

> This deployment uses terraform to setup an environment in azure, but you could create the cluster in another environment if you want to.

## Prerequisites

**Tools needed on your machine**
 - Git
 - Azure Cli
 - Terraform

**Account needed**
 - Service Principal for Azure
 - Nginx Plus repo access

## Setup

 1. Start by cloning this repository
	 - `git clone https://github.com/Gyllenhammar/TF-Azure-KIC-CIS.git`
	 - cd into the directory
2. Setup Terraform
	-  Initilize terraform and all its modules with `terraform init`
	- Now we have to create a file called `terraform.tfvars`
		 >This file contains variable values that are specific to your deployment, you can look in the `variables.tf` file to see what the variables are. 
		 
		 This file need to be populated with the Azure Service principal values, along with some other deployment specific ones. Here is an example
		```
		# Azure Environment
		sp_subscription_id 	=  "XXXX"
		sp_client_id 		=  "XXXX"
		sp_client_secret 	=  "XXXX"
		sp_tenant_id 		=  "XXXX"

		location	 	=  "northeurope" 	# Azure Region.
		adminSrcAddr 		=  "0.0.0.0/0"		# Allowed SSH. 
		vm_count 		=  2			# Number of VMs for cluster.

		# Prefix for objects being created, preferrably use your initials.
		prefix 			=  "AGY-k8s-test"

		# Tags
		purpose 		=  "Prototype for demo"
		environment 		=  "dev"  #ex. dev/staging/prod
		owner 			=  "AGY"
		group 			=  "North-East"
		costcenter 		=  "f5EMEA"
		application 		=  "k8s setup demo"
		```
		 
	- Now we can see what will be changed in our environment with `terraform plan` and apply it with `terraform apply`. After a couple minutes the environment should be up.

	> for windows users
	Generate the Keys using the below command in the windows cli, if not previously created under the folder `C:\\Users\\<username>\\.ssh\\id_rsa.pub` :
	`ssh-keygen -m PEM -t rsa -b 4096`
	Edit the `K8s_cluster.tf` file with the windows path to the generated key -  `public_key = file("C:\\Users\\<username>\\.ssh\\id_rsa.pub")`
 
	Before sshing into the Vm’s, if you are using putty then specify the private key under Authentication parameters / Private key file for authentication

## Environment 

### Azure

We are creating a quite simple environment in azure.

![Azure Diagram](https://mermaid.ink/svg/eyJjb2RlIjoiZ3JhcGggQlRcbiAgICAgICAgQVtWbTFdIFxuICAgICAgICBDe25pYzF9XG4gICAgICAgIEQoU3VibmV0KVxuICAgICAgICBCKFB1YmxpY0lQMSlcbiAgICAgICAgRigoU2VjdXJpdHkgR3JvdXApKVxuICAgICAgICBFKE5ldHdvcmspXG4gICAgICAgIEdbVm0yXVxuICAgICAgICBIKFB1YmxpY0lQMilcbiAgICAgICAgSXtuaWMyfVxuXG4gICAgICAgIEEgLS0-IENcbiAgICAgICAgQiAtLT4gQ1xuICAgICAgICBDIC0tPiBEXG4gICAgICAgIEQgLS0-IEVcbiAgICAgICAgRiAtLT4gQ1xuICAgICAgICBGIC0tPiBEXG4gICAgICAgIEcgLS0-IElcbiAgICAgICAgSCAtLT4gSVxuICAgICAgICBJIC0tPiBEXG4gICAgICAgIEYgLS0-IElcbiIsIm1lcm1haWQiOnsidGhlbWUiOiJkZWZhdWx0In0sInVwZGF0ZUVkaXRvciI6ZmFsc2V9)
 
The *VMs* are reachable on their associated public ip (*which is unknown before deployment*), and the *security group* sets what ip and port is allowed to connect. Terraform also shows this as an output, along with the ssh command to connect to each VM.
> This setup is just for a demo and should not be used in a production environment!

### VMs

The VMs created are Ubuntu 18.04 LTS (*unless changed in the terraform file*). 
The number of VMs is controlled via the variable `vm_count`.

Authentication will be made with the username stored in `vm_admin` and the public key file from your computer, the path (*e.g `~/.ssh/id_rsa.pub`*) is stored in the variable `admin_ssh_public_key`.

Upon creation, we are using *cloud-init* in order to setup and install tools on each VM. The cloud-init script can be viewed in the `/scripts` folder

*What the script does*

 - Updates all packages
 - installs `docker`
 - installs `make`
 - installs `microk8s` version *1.19*
 - adds groups for `docker` and `microk8s` to user
 - enables the modules `dns`, `helm3` and `registry` for `microk8s` 
 - Adds the alias `kubectl=microk8s kubectl`
 - Adds the alias `helm=microk8s helm3`
 - Clones the repository https://github.com/projectcalico/calico
 - Clones the repository https://github.com/nginxinc/kubernetes-ingress
 - Clones the repository https://github.com/Gyllenhammar/TF-Azure-KIC-CIS

>The script can take some time, *approx. 5 minutes* and the user-group commands require a relog to take effect. 

You can follow the scripts output with `tail -f /var/log/cloud-init-output.log`


## Teardown
When you are finished, simply use `terraform destroy` to delete the deployment from azure. 
> Do not close the terminal until terraform has finished.
