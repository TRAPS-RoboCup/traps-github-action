#!/bin/bash
set -e

# setup ros2 environment
source "/opt/ros/humble/setup.bash" --
source "/root/ros2_ws/install/setup.bash" --
exec "$@"