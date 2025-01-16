# traps-github-action/ros2-docker-build

## Usage

``` ros2-docker-build.yaml
name: Docker Build

run-name: Docker Build:${{ github.ref_name }}(${{ github.event.head_commit.message }})

on:
  push:

jobs:
  docker-build:
    runs-on: ubuntu-22.04

    permissions:
      packages: write
      contents: read

    steps:
      # if you want use other package (public) 
      - name: Checkout <package_name>
        uses: actions/checkout@v4
        with:
          path: ./ros2_ws/src/<package_name>
          repository: <public_repository_name>

      # if you want use other package (private) 
      - name: Checkout <package_name>
        uses: actions/checkout@v4
        with:
          path: ./ros2_ws/src/<package_name>
          repository: <private_repository_name>
          token: ${{ secrets.PAT }} # you must set seacrets

      - name: Build and push
        uses: TRAPS-RoboCup/traps-github-action/ros2-docker-build@main
        with:
          checkout: true
          workspace-path: ./ros2_ws
          platforms: linux/amd64, linux/arm64/v8
          rosdistro: humble
          apt-requirements:
```
