#!/bin/bash

# Get the current directory of the script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Build the Docker image with correct permissions
docker build -t orbdock -f Dockerfile --build-arg UID=$(id -u) --build-arg GID=$(id -g) .

# Run the Docker container and start an interactive shell
docker run -it --rm --name orbdock-container -v "$SCRIPT_DIR:/orbdock" orbdock bash -c '
    # Inside the running container
    cd /orbdock  # Change to the mounted directory

    git clone https://github.com/UZ-SLAMLab/ORB_SLAM3.git ORB_SLAM3
    cd ORB_SLAM3
    chmod +x build.sh
    ./build.sh
	
    # Keep the container running
    bash
    cd ..
'

#docker run -it --rm --name orbdock-container -v "$SCRIPT_DIR:/orbdock" orbdock bash 
#docker exec -it orbdock-container bash