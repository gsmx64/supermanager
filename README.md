
SuperManager - (Under Development) - v1.0.0

## Overview

![Super Manager Logo](docs/images/sm_logo_small.png)

SuperManager is an IT management system designed to streamline and optimize your organization's technology operations.


## Features

- **Device Inventory**: Track and manage all IT assets and devices.
- **Software & Script Deployment**: Remotely deploy software and execute scripts across managed devices.
- **Reporting**: Generate detailed reports on device status, software deployments, and inventory.
- **Stock Control**: Monitor and manage consumable supplies and inventory levels.
- **Calendar System**: Organize and schedule IT-related events, maintenance, and tasks.
- **User Management**: Control access, roles, and permissions for system users.
- **Notifications**: Receive alerts and updates for important events and system activities.


**Super Manager - Backend** is the core API and service layer for managing all aspects of IT infrastructure. It provides robust tools for device inventory, software deployment, script execution, reporting, supply stock control, calendar management, user administration, and notifications.

**Repositorio Backend:** [Super Manager Backend en GitHub](https://github.com/gsmx64/supermanager-backend)

**Super Manager - Frontend** is the web interface for managing IT infrastructure, built with modern technologies for a fast and responsive user experience. It connects seamlessly to the backend API to provide tools for device inventory, software deployment, reporting, supply stock control, calendar management, user administration, and notifications.

**Repositorio Frontend:** [Super Manager Frontend en GitHub](https://github.com/gsmx64/supermanager-frontend)


## Technologies Used
- **API Django Rest Framework**: A powerful and flexible backend API built with Django Rest Framework for secure and scalable management of IT resources.
- **React 19**: Modern UI library for building interactive interfaces.
- **React Router v7**: Advanced routing for single-page applications.
- **TypeScript**: Strongly typed language for scalable and maintainable code.
- **Tailwind CSS**: Utility-first CSS framework for rapid UI development.
- **Axios**: HTTP client for connecting to the backend API.


## Infraestructure

1. Clone the repository:
    ```bash
    git clone https://github.com/gsmx64/supermanager.git
    ```
2. Setup a K8S cluster or use K3S cluster deployment using ansible (copy first .env.ansible.sample file to .env.ansible and edit it):
    ```bash
    chmod +x $PWD/k3s/ansible/run.sh
    ./k3s/ansible/run.sh
    ```

## Build

1. Copy first .env.production.sample file to .env.production and edit it, then run:
    ```bash
    chmod +x $PWD/run.sh
    ./run.sh
    ```

## Pre-compiled images

If you prefer not to build the images yourself, you can use the pre-compiled images by running:

- **With Docker Compose:**  
    Use the `docker-compose.yml` or `docker-compose.db.yml` files to quickly start the services.

- **With Kubernetes:**  
    Use the manifests available in the [`kubernetes/`](kubernetes/) folder to deploy on your cluster.

Refer to the documentation in each file for more details on configuration and deployment.


## Contributing

Contributions are welcome! Please open issues or submit pull requests for improvements.

## License

This project is licensed under the MIT License.
