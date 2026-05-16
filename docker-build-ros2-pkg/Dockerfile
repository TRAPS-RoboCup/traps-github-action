# Copyright 2024 TRAPS

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#     http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# builder
FROM  ros:humble-ros-base@sha256:5417e56962ff6e15d4cf9b2f78a71a78f3901f47cd78696b575b7eecdb54eb78 AS builder
ARG ROS_DISTRO="humble"

# ユーザー設定
USER root

# 設定されたワークスペースに移動
WORKDIR /root/ros2_ws

# ROSの依存関係のインストール
RUN apt-get update
RUN rosdep update --rosdistro ${ROS_DISTRO}

# 依存関係のインストール
RUN --mount=type=bind,source=./src,target=/root/ros2_ws/src \
  rosdep install \
    --from-paths src \
    -iy \
    --rosdistro ${ROS_DISTRO} \
    -t build \
    -t buildtool \
    -t buildtool_export \
    -t build_export

# ビルド
FROM builder AS build-cache
ARG ROS_DISTRO="humble"

# ビルド
RUN --mount=type=bind,source=./src,target=/root/ros2_ws/src <<EOF
  set -e
  . /opt/ros/${ROS_DISTRO}/setup.sh
  colcon build --cmake-args -DCMAKE_BUILD_TYPE=Release
EOF

# executor
FROM ros:humble-ros-core@sha256:4cbeac7831833f8d6fa4cb1f9f8e22c188853468e76b3d5b9cc58148a8c8f64b AS executor

# ワークスペスのディレクトリ名と必須aptパッケージの名前
ARG INSTALL_DIR="/root/ros2_ws/install"

# bashrcの設定
RUN echo "source ${INSTALL_DIR}/setup.bash" >> ~/.bashrc

# ws_entry_point.shを作成
RUN <<EOF
  echo "#!/bin/bash" > /ros_ws_entrypoint.sh
  echo "set -e" >> /ros_ws_entrypoint.sh
  echo "source ${INSTALL_DIR}/setup.bash" >> /ros_ws_entrypoint.sh
  echo "exec \"\$@\"" >> /ros_ws_entrypoint.sh
  chmod +x /ros_ws_entrypoint.sh
EOF

# builderからビルドされたアプリケーションをコピー
COPY --from=build-cache /root/ros2_ws/install ${INSTALL_DIR}

# 依存関係のインストール
RUN <<EOF
  # 失敗時にエラーを出す
  set -e

  # rosdepのinstall
  apt-get update
  apt-get install -y --no-install-recommends python3-rosdep2

  # rosdepの更新
  rosdep update --rosdistro ${ROS_DISTRO}

  # ワークスペースの依存関係のインストール
  rosdep install \
    --from-paths ${INSTALL_DIR} \
    -iy \
    --rosdistro ${ROS_DISTRO} \
    -t exec
EOF

# 実行前に行われる操作
ENTRYPOINT ["/ros_ws_entrypoint.sh"]

# 実行時のデフォルトのコマンド
CMD ["bash"]

# test
FROM build-cache AS test-cache

# 依存関係のインストール
RUN --mount=type=bind,source=./src,target=/root/ros2_ws/src \
  rosdep install \
    --from-paths src \
    -iy \
    --rosdistro ${ROS_DISTRO} \
    -t test

# テスト
RUN --mount=type=bind,source=./src,target=/root/ros2_ws/src <<EOF
  set -e
  . /opt/ros/${ROS_DISTRO}/setup.sh
  colcon test
  colcon test-result --all --verbose
EOF