#!/bin/bash

source /opt/ros/$ROS_DISTRO/setup.sh

ros2 launch velodyne velodyne-all-nodes-VLP16-launch.py
