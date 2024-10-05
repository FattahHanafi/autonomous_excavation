FROM docker-swiftnav_gps

RUN apt-get install ros-$ROS_DISTRO-rosbag2* -y
RUN apt-get install ros-$ROS_DISTRO-velodyne -y
RUN apt-get install \
  ros-$ROS_DISTRO-librealsense2* \
  ros-$ROS_DISTRO-realsense2-* -y
RUN apt-get install ros-$ROS_DISTRO-gps-msgs -y

COPY ./entrypoints/bag.sh /ros_ws/
RUN chmod +x /ros_ws/bag.sh
