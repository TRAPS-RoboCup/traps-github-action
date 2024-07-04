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

# リポジトリとws_entry_point.shのコピー
COPY ${WORKSPACE_DIR}/. .
COPY ${ENTRYPOINT_FILE} /ros_ws_entrypoint.sh
RUN chmod +x /ros_ws_entrypoint.sh

# GitHub workfrowで実行時のリモート設定を削除
RUN if [ -f ./src/*/.git/config ]; then sed -i '/\[http "https:\/\/github\.com\/"\]/,+1 d' ./src/*/.git/config; fi

# パッケージのインストール
RUN apt-get update && apt-get upgrade -y
RUN if [ -f ./src/*/config/apt/requirements.txt ]; then for requirements_file in "./src/*/config/apt/requirements.txt"; do xargs -a ${requirements_file} apt-get install -y; done; fi
RUN apt-get install -y ${REQUIRE_APTS} lsb-release wget software-properties-common gnupg
RUN wget https://apt.llvm.org/llvm.sh && chmod +x llvm.sh && ./llvm.sh 18
RUN rosdep update && rosdep install -iy --from-paths src
RUN rm ./llvm.sh && apt-get remove -y lsb-release wget software-properties-common gnupg
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# ビルド
RUN . /opt/ros/humble/setup.sh && colcon build --cmake-args -D CMAKE_C_COMPILER=clang-18 -D CMAKE_CXX_COMPILER=clang++-18
RUN rm -rf ./log

# .bashrcへの書き込み
RUN echo source $(pwd)/install/setup.bash >> ~/.bashrc

# 実行前に行われる操作
ENTRYPOINT ["/ros_ws_entrypoint.sh"]

# 実行時のデフォルトのコマンド
CMD ["bash"]
