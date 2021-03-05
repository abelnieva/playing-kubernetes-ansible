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

## Despligue local (Vagrant & VirtualBox )

```
$ make local up
```

## Despligue local (ansible)

```
$ make local softwareInstall
```
