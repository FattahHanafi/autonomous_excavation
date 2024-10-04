FROM ros:humble-ros-core-jammy
ENV TZ=America/Toronto

RUN apt-get update && apt-get upgrade -y

ENV ROS_DISTRO=humble
