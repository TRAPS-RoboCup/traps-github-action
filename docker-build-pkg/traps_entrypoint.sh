#!/bin/bash
set -e

# setup traps environment
source "/root/traps_ws/install/setup.bash" --
exec "$@"