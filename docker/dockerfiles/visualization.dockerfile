FROM ros:humble-ros-core-jammy

ENV TZ=America/Toronto
ENV ROS_DISTRO=humble

RUN apt-get update && apt-get upgrade -y

RUN apt-get install ros-$ROS_DISTRO-rviz2 -y
RUN apt-get install ros-$ROS_DISTRO-velodyne -y
RUN apt-get install \
  ros-$ROS_DISTRO-librealsense2* \
  ros-$ROS_DISTRO-realsense2-* -y
RUN apt-get install ros-$ROS_DISTRO-gps-msgs -y

COPY ./entrypoints/visualization.sh /ros_ws/
RUN chmod +x /ros_ws/visualization.sh
