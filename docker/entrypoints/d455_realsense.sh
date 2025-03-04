#!/bin/bash

source /opt/ros/$ROS_DISTRO/setup.sh
ros2 launch realsense2_camera rs_launch.py \
  device_type:=d455 \
  camera_name:=D455 \
  depth_module.depth_profile:=1280x720x30 \
  pointcloud.enable:=true \
  rgb_camera.color_profile:=1280x800x30 \
  publish_tf:=true \
  tf_publish_rate:=30 \
  enable_gyro:=true \
  enable_accel:=true \
  enable_sync:=true \
  initial_reset:=true
  # disparity_filter.enable:=true
  # spatial_filter.enable:=true \
  # temporal_filter.enable:=true \
  # hole_filling_filter.enable:=true \
  # decimation_filter.enable:=true
