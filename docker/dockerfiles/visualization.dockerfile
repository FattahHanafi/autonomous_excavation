FROM base_ros_image

RUN apt-get install ros-$ROS_DISTRO-rviz2 -y
RUN apt-get install ros-$ROS_DISTRO-velodyne -y
RUN apt-get install \
  ros-$ROS_DISTRO-librealsense2* \
  ros-$ROS_DISTRO-realsense2-* -y

COPY ./entrypoints/visualization.sh /ros_ws/
RUN chmod +x /ros_ws/visualization.sh
