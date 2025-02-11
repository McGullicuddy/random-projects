#!/bin/bash
# Starting llm, Do you want to update? Yes or no?
printf "Do you want to update before you run the llm? [y/n] "
read decision

echo "Decision made: $decision"

if [ "$decision" = "y" ] || [ "$decision" = "Y" ]; then
    echo "Starting Docker and Ollama services for update..."
    
    # Starting ollama service
    sudo systemctl start ollama
    echo "Ollama service started"
    
    # Starting docker service
    sudo systemctl start docker
    echo "Docker service started"
    
    # Check if open-webui container exists
    image=$(sudo docker ps -a -q --filter "name=open-webui")
    echo "Checking for existing open-webui container..."
    
    if [ -n "$image" ]; then
        echo "Stopping existing open-webui container..."
        sudo docker stop "$image"
        echo "Existing open-webui container stopped"
        
        echo "Removing existing open-webui container..."
        sudo docker rm "$image"
        echo "Existing open-webui container removed"
    fi
    
    echo "Pulling the latest open-webui image..."
    sudo docker pull ghcr.io/open-webui/open-webui:main
    echo "open-webui image pulled successfully"
    
    echo "Starting new open-webui container..."
    sudo docker run -d -p 8080:8080 --net=host -v open-webui:/app/backend/data \
        -e ollama_base_url=http://127.0.0.1:11434 --name open-webui --restart always \
        ghcr.io/open-webui/open-webui:main
    echo "open-webui container started successfully"
elif [ "$decision" = "n" ] || [ "$decision" = "N" ]; then
    echo "Starting Docker and Ollama services..."
    
    # Starting ollama service
    sudo systemctl start ollama
    echo "Ollama service started"
    
    # Starting docker service
    sudo systemctl start docker
    echo "Docker service started"
    
    # Check if open-webui container exists
    image=$(sudo docker ps -a -q --filter "name=open-webui")
    echo "Checking for existing open-webui container..."
    
    if [ -n "$image" ]; then
        echo "open-webui container already running. Poggers!"
    else
        echo "No existing open-webui container found. Starting new instance..."
        
        sudo docker run -d -p 8080:8080 --net=host -v open-webui:/app/backend/data \
            -e ollama_base_url=http://127.0.0.1:11434 --name open-webui --restart always \
            ghcr.io/open-webui/open-webui:main
        echo "open-webui container started successfully"
    fi
else
    echo "Invalid input. Exiting..."
    exit 1
fi
