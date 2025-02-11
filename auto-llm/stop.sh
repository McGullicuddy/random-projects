#!/bin/bash
# This script shuts down the Ollama service, Docker service, and the open-webui Docker container.

echo "=== Starting shutdown process ==="


# 1. Check if the open-webui container exists and perform cleanup
container_id=$(sudo docker ps -a -q --filter "name=open-webui")
if [ -n "$container_id" ]; then
    echo "Found running open-webui container."
    sudo docker stop "$container_id"
    echo "open-webui container stopped."
    
    sudo docker rm "$container_id"
    echo "open-webui container removed."
else
    echo "No open-webui container found. Nothing to remove."
fi

# 2. Stopping deepseek model 
sudo ollama stop deepseek-r1:14b
echo "Ollama Deepseek Model Stopped"

# 1. Stopping Ollama service
sudo systemctl stop ollama
echo "Ollama service stopped."

# 2. Stopping Docker service
sudo systemctl stop docker.socket
sudo systemctl stop docker.service
sudo systemctl stop docker
echo "Docker service stopped."

echo "=== Shutdown process completed ==="
