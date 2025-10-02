#!/bin/bash

check_root() {
    if [ "$(id -u)" -eq 0 ]; then
        echo " "
        echo "---------------------------------------------------------------------"
        echo ">>> Running as root."
        echo "---------------------------------------------------------------------"
    elif pgrep -s 0 '^sudo$' > /dev/null ; then
        echo " "
        echo "---------------------------------------------------------------------"
        echo ">>> Running with sudo."
        echo "---------------------------------------------------------------------"
    else
        echo " "
        echo "---------------------------------------------------------------------"
        echo ">>> ERROR: This script must be run as root or with sudo. Exiting..."
        echo "---------------------------------------------------------------------"
        exit 1
    fi
}

echo "---------------------------------------------------------------------"
echo " "
echo " >>> Running k3s Cluster Setup Script"
echo " "
echo "---------------------------------------------------------------------"
sleep 2

if [ -n "$pgpass" ]; then
    sudo sed -i "s/VPSK3S01_IP/$VPSK3S01_IP/g" $PWD/inventory
fi
if [ -n "$pgpass" ]; then
    sudo sed -i "s/VPSK3S01_USER/$VPSK3S01_USER/g" $PWD/inventory
fi

# Run Ansible Playbook
export ANSIBLE_HOST_KEY_CHECKING=False && export DEFAULT_KEEP_REMOTE_FILES=yes && sudo ansible-playbook --inventory-file ./inventory -vvv ./k3s.yml --private-key ../gsmcfdevops --key-file ../gsmcfdevops.pub --user gsmcfdevops

echo " "
echo "-------------------------------------------------"
echo " > All task completed!"
echo "-------------------------------------------------"

sleep 2
