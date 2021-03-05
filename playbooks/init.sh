#!/bin/bash

dnf makecache
dnf install -y epel-release
dnf makecache
dnf install -y ansible
ansible --version
