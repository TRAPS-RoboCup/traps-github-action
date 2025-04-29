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
ARG ROS_DISTRO=humble

# プラットフォームとベースのイメージを設定
FROM ros:${ROS_DISTRO}

# ワークスペスのディレクトリ名と必須aptパッケージの名前
ARG PRE_IMPORT_SCRIPT=""
ARG GIT_REMOTE_URL
ARG GIT_SHA
ARG POST_IMPORT_SCRIPT=""
ARG GIT_CLONE_OPTIONS="--depth 1 --recurse-submodules"
ARG REPOS_FILES="*.repos"

# ユーザー設定
USER root

# ビルドとgitの設定の実行
RUN <<EOF
  set -e

  # make & cd workdir
  WORKSPACE_DIR=$(mktemp -d)
  cd ${WORKSPACE_DIR}

  # pre import script
  ${PRE_IMPORT_SCRIPT}

  # git clone
  mkdir -p src/$(basename -s .git ${GIT_REMOTE_URL})
  cd src/$(basename -s .git ${GIT_REMOTE_URL})
  git init
  git remote add origin ${GIT_REMOTE_URL}
  git fetch --depth 1 origin ${GIT_SHA}
  git checkout FETCH_HEAD
  cd ${WORKSPACE_DIR}

  # vcs import
  for REPOS_FILE in src/*/${REPOS_FILES}; do
    if [ ! -f ${REPOS_FILE} ]; then continue; fi
    vcs import src < "${REPOS_FILE}"
  done

  # post import script
  ${POST_IMPORT_SCRIPT}

  # パッケージのインストール
  apt-get update
  rosdep update --rosdistro=${ROS_DISTRO}
  rosdep install -iy --from-paths src --rosdistro=${ROS_DISTRO}
  apt-get clean
  rm -rf /var/lib/apt/lists/*

  # rm workdir
  cd /
  rm -rf ${WORKSPACE_DIR}
EOF

# 実行前に行われる操作
ENTRYPOINT ["/ros_entrypoint.sh"]

# 実行時のデフォルトのコマンド
CMD ["bash"]
