FROM ros:humble-ros-core-jammy

ENV TZ=America/Toronto
ENV ROS_DISTRO=humble

RUN apt-get update && apt-get upgrade -y