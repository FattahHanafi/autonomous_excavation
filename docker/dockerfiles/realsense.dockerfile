FROM base_ros_image

RUN apt-get install \
  ros-$ROS_DISTRO-librealsense2* \
  ros-$ROS_DISTRO-realsense2-* -y

COPY ./entrypoints/d455_realsense.sh /ros_ws/
COPY ./entrypoints/d415_realsense.sh /ros_ws/
RUN chmod +x /ros_ws/d455_realsense.sh
RUN chmod +x /ros_ws/d415_realsense.sh
