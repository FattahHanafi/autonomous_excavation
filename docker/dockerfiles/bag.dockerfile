FROM base_ros_image

RUN apt-get install \
ros-$ROS_DISTRO-rosbag2* -y
# ros-$ROS_DISTRO-rosbag2-storage-mcap -y

RUN apt-get install ros-$ROS_DISTRO-velodyne -y
RUN apt-get install \
  ros-$ROS_DISTRO-librealsense2* \
  ros-$ROS_DISTRO-realsense2-* -y

COPY ./entrypoints/bag.sh /ros_ws/
RUN chmod +x /ros_ws/bag.sh
