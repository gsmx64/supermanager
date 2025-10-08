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

check_root

# Install Ansible if not present
apt update && apt upgrade -y
if ! command -v ansible &> /dev/null; then
    echo "Ansible not found, installing..."
    apt install ansible
else
    echo "Ansible is already installed."
    ansible --version
    sleep 2
fi

# Prepare environment file
if [ -f $PWD/.env.ansible.sample ]; then
    if [ -f $PWD/.env.ansible ]; then
        echo " "
        echo "---------------------------------------------------------------------"
        echo ">>> .env.ansible file already exists. Using existing file."
        echo "---------------------------------------------------------------------"
        sleep 2
    else
        echo " "
        echo "---------------------------------------------------------------------"
        echo ">>> Creating .env.ansible file from .env.ansible.sample template."
        echo "---------------------------------------------------------------------"
        cp .env.ansible.sample .env.ansible
        sleep 2
    fi
else
    echo " "
    echo "---------------------------------------------------------------------"
    echo ">>> ERROR: .env.ansible.sample file not found! Exiting..."
    echo "---------------------------------------------------------------------"
    exit 1
fi

# Edit environment file
if [ -f $PWD/.env.ansible ]; then
    echo " "
    echo "---------------------------------------------------------------------"
    echo ">>> Edit .env.ansible file to set your environment variables as needed."
    echo "---------------------------------------------------------------------"
    sleep 2

    # Check if nano or vi exists, install if missing
    if ! command -v nano &> /dev/null; then
        echo "nano not found, installing..."
        apt update && apt install -y nano
    fi
    if ! command -v vi &> /dev/null; then
        echo "vi not found, installing..."
        apt update && apt install -y vim
    fi

    echo "Choose editor to open .env.ansible:"
    select editor in "nano" "vi"; do
        case $editor in
            nano ) nano .env.ansible; break;;
            vi ) vi .env.ansible; break;;
            * ) echo "Invalid option. Please select 1 or 2.";;
        esac
    done
    source $PWD/.env.ansible
else
    echo " "
    echo "---------------------------------------------------------------------"
    echo ">>> ERROR: .env.ansible file not found! Exiting..."
    echo "---------------------------------------------------------------------"
    exit 1
fi

# Check if environment variables have values
if [ -z "$VPSK3S01_IP" ]; then
    echo " "
    echo "---------------------------------------------------------------------"
    echo ">>> ERROR: Variables not have been set correctly the values! Exiting..."
    echo "---------------------------------------------------------------------"
    exit 1
fi

# Prepare inventory file
if [ -f $PWD/inventory ]; then
    sed -i "s/VPSK3S01_IP/$VPSK3S01_IP/g" $PWD/inventory
    sed -i "s/VPSK3S01_USER/$VPSK3S01_USER/g" $PWD/inventory
else
    echo " "
    echo "---------------------------------------------------------------------"
    echo ">>> ERROR: inventory file not found! Exiting..."
    echo "---------------------------------------------------------------------"
    exit 1
fi

# Prepare ansible tasks file
if [ -f $PWD/roles/main/tasks/main.yml ]; then
    sed -i "s/VPSK3S01_IP/$VPSK3S01_IP/g" $PWD/roles/main/tasks/main.yml
    sed -i "s/VPSK3S01_USER/$VPSK3S01_USER/g" $PWD/roles/main/tasks/main.yml
    sed -i "s/K3S_DB_ENDPOINT/$K3S_DB_ENDPOINT/g" $PWD/roles/main/tasks/main.yml
    sed -i "s/K3S_FIXED_IP/$K3S_FIXED_IP/g" $PWD/roles/main/tasks/main.yml
    sed -i "s/SUPERMANAGER_DB_USER/$SUPERMANAGER_DB_USER/g" $PWD/roles/main/tasks/main.yml
    sed -i "s/SUPERMANAGER_DB_PASSWORD/$SUPERMANAGER_DB_PASSWORD/g" $PWD/roles/main/tasks/main.yml
    sed -i "s/SUPERMANAGER_DB_NAME/$SUPERMANAGER_DB_NAME/g" $PWD/roles/main/tasks/main.yml
    sed -i "s/SUPERMANAGER_VPS_USER/$SUPERMANAGER_VPS_USER/g" $PWD/roles/main/tasks/main.yml
    sed -i "s/SUPERMANAGER_VPS_PASSWORD/$SUPERMANAGER_VPS_PASSWORD/g" $PWD/roles/main/tasks/main.yml
    sed -i "s/SUPERMANAGER_VPS_DB_NAME/$SUPERMANAGER_VPS_DB_NAME/g" $PWD/roles/main/tasks/main.yml
    sed -i "s/POSTGRES_ROOT_PASSWORD/$POSTGRES_ROOT_PASSWORD/g" $PWD/roles/main/tasks/main.yml
    sed -i "s/GRAFANA_ADMIN_PASSWORD/$GRAFANA_ADMIN_PASSWORD/g" $PWD/roles/main/tasks/main.yml
else
    echo " "
    echo "---------------------------------------------------------------------"
    echo ">>> ERROR: ansible tasks file not found! Exiting..."
    echo "---------------------------------------------------------------------"
    exit 1
fi

# Run Ansible Playbook
export ANSIBLE_PERSISTENT_COMMAND_TIMEOUT=60 && export ANSIBLE_HOST_KEY_CHECKING=False && export DEFAULT_KEEP_REMOTE_FILES=yes && ansible-playbook -K --inventory-file ./inventory -vvv ./k3s.yml --private-key $VPSK3S01_SSH_KEY --key-file $VPSK3S01_SSH_KEY_PUB --user $VPSK3S01_USER --extra-vars "ansible_ssh_port=$VPSK3S01_SSH_PORT ansible_ssh_private_key_file=$VPSK3S01_SSH_KEY ansible_ssh_common_args='-o StrictHostKeyChecking=no'"

echo " "
echo "-------------------------------------------------"
echo " > All task completed!"
echo "-------------------------------------------------"

sleep 3
