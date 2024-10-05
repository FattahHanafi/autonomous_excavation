ARG UBUNTU_MAJOR=22
ARG UBUNTU_MINOR=04
ARG CUDA_MAJOR=12
ARG CUDA_MINOR=1
ARG CUDA_PATCH=0
ARG ZED_SDK_MAJOR=4
ARG ZED_SDK_MINOR=1
ARG ZED_SDK_PATCH=4

ARG IMAGE_NAME=nvcr.io/nvidia/cuda:${CUDA_MAJOR}.${CUDA_MINOR}.${CUDA_PATCH}-devel-ubuntu${UBUNTU_MAJOR}.${UBUNTU_MINOR}

FROM ${IMAGE_NAME}

ARG UBUNTU_MAJOR=22
ARG UBUNTU_MINOR=04
ARG CUDA_MAJOR=12
ARG CUDA_MINOR=1
ARG CUDA_PATCH=0
ARG ZED_SDK_MAJOR=4
ARG ZED_SDK_MINOR=1
ARG ZED_SDK_PATCH=4

ENV TZ=America/Toronto

RUN apt-get update && apt-get upgrade -y

ENV ROS_DISTRO=humble

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get install \
  apt-utils \
  dialog \
  curl \
  lsb-release \
  wget \
  less \
  udev \
  sudo \
  build-essential \
  cmake \
  python3 \
  python3-dev \
  python3-pip \
  python3-wheel \
  git \
  jq \
  libopencv-dev \
  libpq-dev \
  zstd \
  usbutils \
  software-properties-common -y

RUN add-apt-repository universe
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg

RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null

# Install ROS 2 Base packages and Python dependencies
RUN apt-get update && apt-get install \
  ros-${ROS_DISTRO}-ros-base \
  ros-${ROS_DISTRO}-ament-cmake-clang-format \
  ros-${ROS_DISTRO}-image-transport \
  ros-${ROS_DISTRO}-image-transport-plugins \
  ros-${ROS_DISTRO}-diagnostic-updater \
  ros-${ROS_DISTRO}-xacro \
  python3-flake8-docstrings \
  python3-pytest-cov \
  ros-dev-tools -y 

RUN pip3 install \
  argcomplete \
  numpy \
  empy \
  lark

RUN rosdep init && rosdep update

RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install \
  numpy \
  opencv-python-headless


ENV ZED_SDK_URL="https://stereolabs.sfo2.cdn.digitaloceanspaces.com/zedsdk/${ZED_SDK_MAJOR}.${ZED_SDK_MINOR}/ZED_SDK_Ubuntu${UBUNTU_MAJOR}_cuda${CUDA_MAJOR}.${CUDA_MINOR}_v${ZED_SDK_MAJOR}.${ZED_SDK_MINOR}.${ZED_SDK_PATCH}.zstd.run"

RUN wget -O ZED_SDK_Linux_Ubuntu.run ${ZED_SDK_URL}
RUN chmod +x ZED_SDK_Linux_Ubuntu.run 
RUN ./ZED_SDK_Linux_Ubuntu.run -- silent
RUN ln -sf /lib/x86_64-linux-gnu/libusb-1.0.so.0 /usr/lib/x86_64-linux-gnu/libusb-1.0.so

WORKDIR /ros_ws/
RUN git clone --recursive --branch ${ROS_DISTRO}-v${ZED_SDK_MAJOR}.${ZED_SDK_MINOR}.${ZED_SDK_PATCH} https://github.com/stereolabs/zed-ros2-wrapper.git
RUN git clone --recursive --branch ${ROS_DISTRO}-v${ZED_SDK_MAJOR}.${ZED_SDK_MINOR}.${ZED_SDK_PATCH} https://github.com/stereolabs/zed-ros2-examples.git

RUN /bin/bash -c "source /opt/ros/$ROS_DISTRO/setup.bash && \ 
  rosdep update && \
  rosdep install --from-paths . --ignore-src -r -y"

RUN /bin/bash -c "source /opt/ros/$ROS_DISTRO/setup.bash && \ 
  colcon build --parallel-workers $(nproc) --symlink-install \
  --event-handlers console_direct+ --base-paths . \
  --cmake-args ' -DCMAKE_BUILD_TYPE=Release' \
  ' -DCMAKE_LIBRARY_PATH=/usr/local/cuda/lib64/stubs' \
  ' -DCMAKE_CXX_FLAGS="-Wl,--allow-shlib-undefined"' "

WORKDIR /
COPY ./entrypoints/zed2i_stereolabs.sh /ros_ws/
RUN chmod +x /ros_ws/zed2i_stereolabs.sh
