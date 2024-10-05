#!/bin/bash

docker exec -it bag bash -c "source /opt/ros/humble/setup.sh && cd /ros_ws/bag && ros2 bag record -s mcap -a"
