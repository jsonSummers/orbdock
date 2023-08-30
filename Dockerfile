FROM nvidia/opengl:1.2-glvnd-runtime-ubuntu18.04

RUN apt-get update

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y gnupg2 curl lsb-core vim wget python-pip libpng16-16 libjpeg-turbo8 libtiff5

RUN apt-get install -y \
        # Base tools
        cmake \
        build-essential \
        git \
        unzip \
        pkg-config \
        python-dev \
        # OpenCV dependencies
        python-numpy \
        # Pangolin dependencies
        libgl1-mesa-dev \
        libglew-dev \
        libpython2.7-dev \
        libeigen3-dev \
        apt-transport-https \
        ca-certificates\
        software-properties-common

RUN curl -fsSL https://download.sublimetext.com/sublimehq-pub.gpg | apt-key add -
RUN add-apt-repository "deb https://download.sublimetext.com/ apt/stable/"
RUN apt update
RUN apt install -y sublime-text

# Build OpenCV (3.0 or higher should be fine)
RUN apt-get install -y python3-dev python3-numpy 
RUN apt-get install -y python-dev python-numpy
RUN apt-get install -y libavcodec-dev libavformat-dev libswscale-dev
RUN apt-get install -y libgstreamer-plugins-base1.0-dev libgstreamer1.0-dev
RUN apt-get install -y libgtk-3-dev

RUN cd /tmp && git clone https://github.com/opencv/opencv.git && \
    cd opencv && \
    git checkout 3.2.0 && \
    mkdir build && cd build && \
    cmake -D CMAKE_BUILD_TYPE=Release -D BUILD_EXAMPLES=OFF  -D BUILD_DOCS=OFF -D BUILD_PERF_TESTS=OFF -D BUILD_TESTS=OFF -D CMAKE_INSTALL_PREFIX=/usr/local .. && \
    make -j$nproc && make install && \
    cd / && rm -rf /tmp/opencv

# # Build Pangolin
RUN cd /tmp && git clone https://github.com/stevenlovegrove/Pangolin && \
    cd Pangolin && git checkout v0.6 && mkdir build && cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS=-std=c++11 .. && \
    make -j$nproc && make install && \
    cd / && rm -rf /tmp/Pangolin

USER $USERNAME
# terminal colors with xterm
ENV TERM xterm
RUN mkdir /ORB_SLAM3
WORKDIR /ORB_SLAM3
CMD ["bash"]