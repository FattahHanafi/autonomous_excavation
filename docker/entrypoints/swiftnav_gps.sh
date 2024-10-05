#!/bin/bash

source /opt/ros/$ROS_DISTRO/setup.sh
cd /ros_ws && source install/setup.sh

ros2 launch swiftnav_ros2_driver start.py