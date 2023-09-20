# Dockerizing OCS Inventory Server

This guide explains how to create a Docker image for the OCS Inventory Server setup.

## Steps

### Step 1: Clone the repository
Clone the repository and open terminal in the repository folder.

### Step 2: Build the docker image
docker build -t ocs-inventory-server:latest .

### Step 3: Run the Docker Container
docker run -d -p 80:80 --name ocs-inventory-server ocs-inventory-server:latest

### Step 4: Access the OCS Inventory Server
Open a web browser and navigate to http://localhost:80 
Log in with the default credentials (admin/admin) to verify the server's functionality.


