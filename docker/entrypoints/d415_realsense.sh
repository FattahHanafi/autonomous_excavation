#!/bin/bash

source /opt/ros/$ROS_DISTRO/setup.sh
ros2 launch realsense2_camera rs_launch.py \
  device_type:=d415 \
  camera_name:=D415 \
  pointcloud.enable:=true \
  pointcloud.ordered_pc:=true \
  align_depth:=true \
  enable_infra:=false \
  enable_color:=true \
  enable_depth:=true \
  enable_gyro:=true \
  enable_accel:=true \
  rgb_camera.color_profile:=1280x720x30 \
  depth_module.depth_profile:=1280x720x30 \
  enable_sync:=true \
  initial_reset:=true 