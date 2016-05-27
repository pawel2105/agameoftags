#!/usr/bin/expect

cd ansible
spawn ansible-playbook playbooks/upload_latest.yml -i playbooks/hosts -K
expect "SUDO password: " { send "mypass\r" }
interact