FROM ros:humble-ros-core-jammy

ENV TZ=America/Toronto
ENV ROS_DISTRO=humble

RUN apt-get update && apt-get upgrade -y

RUN apt-get install ros-$ROS_DISTRO-velodyne -y

COPY ./entrypoints/vlp16_lidar.sh /ros_ws/
RUN chmod +x /ros_ws/vlp16_lidar.sh
