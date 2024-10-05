FROM base_ros_image

RUN apt-get install ros-$ROS_DISTRO-velodyne -y

COPY ./entrypoints/vlp16_lidar.sh /ros_ws/
RUN chmod +x /ros_ws/vlp16_lidar.sh
