#!/bin/bash

source /opt/ros/$ROS_DISTRO/setup.sh
cd /ros_ws && source install/setup.sh

ros2 launch zed_wrapper zed_camera.launch.py camera_model:=zed2i

