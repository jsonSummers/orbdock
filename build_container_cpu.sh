#!/bin/bash

# Function to replace files
replace_files() {
    # Copy files
    cp ./Modified_files/Map.cc ./ORB_SLAM3/src/Map.cc
    cp Modified_files/MapPoint.cc ORB_SLAM3/src/MapPoint.cc
    cp Modified_files/MapPoint.h ORB_SLAM3/include/MapPoint.h
	cp ./Modified_files/Tracking.cc ./ORB_SLAM3/src/Tracking.cc
	cp ./Modified_files/LoopClosing.cc ./ORB_SLAM3/src/LoopClosing.cc
}


###########################################################################

# UI permisions
XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.xauth
touch $XAUTH
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -

xhost +local:docker

docker pull jahaniam/orbslam3:ubuntu20_noetic_cpu

# Remove existing container
docker rm -f orbslam3 &>/dev/null
[ -d "ORB_SLAM3" ] && sudo rm -rf ORB_SLAM3 && mkdir ORB_SLAM3

# Create a new container
docker run -td --privileged --net=host --ipc=host \
    --name="orbslam3" \
    -e "DISPLAY=$DISPLAY" \
    -e "QT_X11_NO_MITSHM=1" \
    -v "/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    -e "XAUTHORITY=$XAUTH" \
    -e ROS_IP=127.0.0.1 \
    --cap-add=SYS_PTRACE \
    -v `pwd`/Datasets:/Datasets \
    -v /etc/group:/etc/group:ro \
    -v `pwd`/ORB_SLAM3:/ORB_SLAM3 \
    -v "$(pwd)/../study:/study" \
    jahaniam/orbslam3:ubuntu20_noetic_cpu bash


# Git pull orbslam and compile (using HTTPS)
#docker exec -i orbslam3 bash -c "git clone -b add_euroc_example.sh https://github.com/jahaniam/ORB_SLAM3.git /ORB_SLAM3 && cd /ORB_SLAM3 && chmod +x build.sh && ./build.sh "
docker exec -i orbslam3 bash -c "git clone -b add_euroc_example.sh https://github.com/jahaniam/ORB_SLAM3.git /ORB_SLAM3"

replace_files

docker exec -i orbslam3 bash -c "cd /ORB_SLAM3 && chmod +x build.sh && ./build.sh "

# Access the container
echo "To access the container, run: docker exec -it orbslam3 bash"