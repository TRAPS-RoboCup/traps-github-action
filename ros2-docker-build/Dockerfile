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

# イメージ引数設定
ARG BASE_IMAGE

# プラットフォームとベースのイメージを設定
FROM ${BASE_IMAGE}

# ワークスペスのディレクトリ名と必須aptパッケージの名前
ARG WORKSPACE_DIR
ARG ENTRYPOINT_FILE
ARG REQUIRE_APTS

# 設定されたワークスペースに移動
WORKDIR /root/ros2_ws

# ユーザー設定
USER root

# ws_entry_point.shのコピー
COPY ${ENTRYPOINT_FILE} /ros_ws_entrypoint.sh

# bashrcの設定
RUN echo "source $(pwd)/install/setup.bash" >> ~/.bashrc

# apt upgrade
RUN <<EOF
  apt-get update
  apt-get upgrade -y --no-install-recommends
  apt-get clean
  rm -rf /var/lib/apt/lists/*
EOF

# ワークスペースのコピー
COPY ${WORKSPACE_DIR}/. .

# ビルドとgitの設定の実行
RUN <<EOF
  # GitHub workfrowで実行時のリモート設定を削除
  if [ -f ./src/*/.git/config ]; then sed -i '/\[http "https:\/\/github\.com\/"\]/,+1 d' ./src/*/.git/config; fi

  # パッケージのインストール
  rosdep update
  rosdep install -iy --from-paths src
  apt-get clean
  rm -rf /var/lib/apt/lists/*

  # ビルド
  . /opt/ros/humble/setup.sh
  colcon build --cmake-args -DCMAKE_BUILD_TYPE=Release
  rm -rf ./log ./build ./src
EOF

# 実行前に行われる操作
ENTRYPOINT ["/ros_ws_entrypoint.sh"]

# 実行時のデフォルトのコマンド
CMD ["bash"]
