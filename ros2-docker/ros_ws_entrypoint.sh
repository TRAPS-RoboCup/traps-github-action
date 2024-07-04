#!/bin/bash
set -e

# setup ros2 environment
source "/root/ros2_ws/install/setup.bash" --
exec "$@"