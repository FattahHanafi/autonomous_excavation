FROM ros:humble

ENV TZ=America/Toronto
ENV ROS_DISTRO=humble

RUN apt-get update && apt-get upgrade -y

RUN apt-get install \
  apt-utils \
  build-essential \
  pkg-config \
  cmake \
  doxygen \
  check \
  clang-format-13 \
  libserialport-dev \
  git -y

RUN apt-get install \
  ros-$ROS_DISTRO-gps-msgs -y

WORKDIR /ros_ws/
RUN git clone --depth=1 --recursive --branch v4.11.0 https://github.com/swift-nav/libsbp.git
RUN mkdir -p libsbp/c/build && \
  cd libsbp/c/build && \
  cmake -DCMAKE_CXX_STANDARD=17 -DCMAKE_CXX_STANDARD_REQUIRED=ON -DCMAKE_CXX_EXTENSIONS=OFF ../ && \
  make -j4 && \
  make install

ARG SONAR_SCANNER_VERSION=6.1.0.4477

RUN apt-get install \
  gcovr \
  unzip \
  curl -y
RUN mkdir -p sonar && \
    curl -sSLo sonar/sonar-scanner.zip https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VERSION}-linux-x64.zip && \
    unzip -o sonar/sonar-scanner.zip -d sonar/

ENV PATH="/ros_ws/sonar/sonar-scanner-${SONAR_SCANNER_VERSION}-linux-x64/bin:${PATH}"

RUN git clone https://github.com/swift-nav/swiftnav-ros2.git
RUN /bin/bash -c "source /opt/ros/$ROS_DISTRO/setup.bash && \ 
  rosdep update && \
  rosdep install --from-paths . --ignore-src -r -y"

RUN /bin/bash -c "source /opt/ros/$ROS_DISTRO/setup.bash && \ 
  colcon build --cmake-args -DCMAKE_BUILD_TYPE=Release"

WORKDIR /
COPY ./entrypoints/swiftnav_gps.sh /ros_ws/
RUN chmod +x /ros_ws/swiftnav_gps.sh
