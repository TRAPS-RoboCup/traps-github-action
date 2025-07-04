# Copyright 2025 TRAPS

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#     http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# base images name
ARG BUILDER_BASE_IMAGE=ubuntu:latest
ARG EXECUTOR_BASE_IMAGE=ubuntu:latest

# set base image(build)
FROM ${BUILDER_BASE_IMAGE} AS builder

# workdir
WORKDIR "/root/traps_ws"

# copy packages
ARG HOST_PACKAGES_PATH="src"
COPY "${HOST_PACKAGES_PATH}" "src"

# install build dependencies
ARG BUILD_DEPENDS_INSTALL_SCRIPT=""
RUN bash -c "${BUILD_DEPENDS_INSTALL_SCRIPT}"

# colcon build
ARG PRE_BUILD_SCRIPT=". /opt/ros/${ROS_DISTRO}/setup.sh"
ARG BUILD_OPTIONS="--merge-install --executor sequential --cmake-args -DCMAKE_BUILD_TYPE=Release"
ARG POST_BUILD_SCRIPT="rm -rf log"
RUN <<EOF
  set -e
  ${PRE_BUILD_SCRIPT}
  MAKEFLAGS=-j$(nproc) colcon build ${BUILD_OPTIONS}
  ${POST_BUILD_SCRIPT}
EOF

# set base image(executor)
FROM ${EXECUTOR_BASE_IMAGE} AS executor

# workdir
WORKDIR "/root/traps_ws"

# copy entrypoint script
RUN <<EOF
  set -e
  echo "#!/bin/bash"                       >  /traps_entrypoint.sh
  echo "set -e"                            >> /traps_entrypoint.sh
  echo ""                                  >> /traps_entrypoint.sh
  echo "# source traps environment"        >> /traps_entrypoint.sh
  echo ". /opt/ros/${ROS_DISTRO}/setup.sh" >> /traps_entrypoint.sh
  echo "exec \"\$@\""                      >> /traps_entrypoint.sh
  chmod +x /traps_entrypoint.sh
EOF

# copy build result
COPY --from=builder "/root/traps_ws/install" "install"

# install exec dependencies
ARG EXEC_DEPENDS_INSTALL_SCRIPT=""
RUN bash -c "${EXEC_DEPENDS_INSTALL_SCRIPT}"

# entrypoint & cmd
ENTRYPOINT ["/traps_entrypoint.sh"]
CMD ["bash"]

# set base image(tester)
FROM builder AS tester

# workdir
WORKDIR "/root/traps_ws"

# install build dependencies
ARG TEST_DEPENDS_INSTALL_SCRIPT=""
RUN bash -c "${TEST_DEPENDS_INSTALL_SCRIPT}"

# colcon test
RUN <<EOF
  colcon test
  colcon test-result --verbose
EOF