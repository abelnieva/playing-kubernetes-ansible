#!/bin/bash
## esta funcion prepara el bastion para usar ansible 
dnf makecache
dnf install -y epel-release
dnf makecache
dnf install -y ansible
ansible --version
