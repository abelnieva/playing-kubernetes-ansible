# Despligue de cluster kubernetes en con Ansible, terraform , Vagrant 

Este repositorio fue creado inicialmente como resolucion del Trabajo prático 2 de Experto univesitario de  UNIR 

## Despligue de componentes 

![infra](imgs/infra.png)
 
 -----------------------------------------------------------------
| Role | Sistema Operativo | vCPUs | Memoria (GiB) | Disco Duro |  DNS | IP |
|------|-------------------|-------|---------------|------------| ----------- | --------------|
| NFS  | CentOS 8.3          | 2     | 4             | 1 x 20 GiB (boot), 1 x 10 GiB (data) | nfs.acme.es  | 192.168.2.115/24
| Master | CentOS 8.3        | 2     | 8             | 1 x 20 GiB (boot) | master.acme.es  | 192.168.2.110/24
| Worker 01 | CentOS 8.3        | 2     | 4             | 1 x 20 GiB (boot) |  worker01.acme.es | 192.168.2.111/24 | 
| Worker02 | CentOS 8.3        | 2     | 4             | 1 x 20 GiB (boot) |  worker02.acme.es | 192.168.2.112/24 | 
| Bastion | CentOS 8.3        | 2     | 4             | 1 x 20 GiB (boot) |  n/a | n/a | 

Nota el bastion solo se despliega en la nube. 
## Requerimientos software
Para la versión local 

* Virtual Box
* Vagrant 
* Ansible 
* python

Para la versión en azure 
* Ansible 
* terraform 
* azure cli 
* python

Para verificar los requerimientos podemos usar ejecutar 

```
$ make checkReq
```
## ¿ Dónde puedo declarar la infrastructura en local ?

El archivo [Vagrantfile](Vagrantfile) dispone de una variable 
```
nodes = [
  { :hostname => 'master',   :ip => '192.168.2.110', :box => 'centos/8', :ram => 2000, :dns => 'master master.acme.es'},
  { :hostname => 'worker01',      :ip => '192.168.2.111', :box => 'centos/8', :ram => 1000 , :dns => 'worker01 worker01.acme.es' },
  { :hostname => 'worker02',    :ip => '192.168.2.112', :box => 'centos/8' , :ram => 1000,  :dns => 'worker02 worker02.acme.es5' },
  { :hostname => 'nfs',    :ip => '192.168.2.115', :box => 'centos/8' , :ram => 1000 ,  :dns => 'nfs nfs.acme.es' },
]
```

## Despligue local (Vagrant & VirtualBox )

```
$ make local up
```

## Despligue local (ansible)

```
$ make local softwareInstall
```


## Despligue en azure 

Creación de la cuenta de azure. 

## Configuración de credenciales 

Recomendamos seguir los siguientes [pasos](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret) para la creación de la service principal account. 

Los datos de logueos se deben guardar en un archivo llamado azcreds.json, de esta manera el siguente comando configurara tu shell para su uso. 

Ejemplo  del archivo json de credenciales  

```
{
  "appId": "42356afe-988d398d",
  "displayName": "azur-05-59",
  "name": "http://azur5-59",
  "password": "7eh2ftGdGHyhyo7N",
  "tenant": "899789dc-b440"
}
```


```
$ make azuresetupCreds
```

## Terraform 

Para inicializar el proyecto debemos ejecutar 


```
$ make terraformUp
```
## ¿ Dónde puedo declarar la infrastructura en local ?

mirar el directorio [terraform](terraform)

## Generación ssh keypair 

Este par de claves son importantes para que terraform pueda conectarse al basion , y eventualmente nosotros tambien lo podremos hacer. 

```
$ make setupSshKeyPair
```


## Automatizaciones con terraform 
Si queremos hacer un plan de cambios 

```
$ make terraformPlan
```

o simplemente podemos destruir todo con el siguiente comando 


```
$ make terraformDestroy
```

## Ansible  

Si quisieramos que terraform aplique cambios realizados a los playbook 

```
$ make terraformRunPlaybooks 
```

## Despligue de apps en kubernetes 

```
$ make appsReDeploy 
```

Si deseamos desplegar cambios en apps por entorno 


```
$ make appsReDeploy  desarrollo
```

```
$ make appsReDeploy  produccion
```