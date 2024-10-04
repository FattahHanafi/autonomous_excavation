#!/bin/bash

source /opt/ros/$ROS_DISTRO/setup.sh
ros2 launch realsense2_camera rs_launch.py \
  device_type:=d455 \
  camera_name:=D455 \
  pointcloud.enable:=true \
  pointcloud.ordered_pc:=true \
  align_depth:=true \
  enable_infra:=true \
  enable_color:=true \
  enable_depth:=true \
  depth_module.infra_profile:=1280x720x30 \
  rgb_camera.color_profile:=1280x800x30 \
  depth_module.depth_profile:=1280x720x30 \
  enable_sync:=true \
  initial_reset:=true 
