# traps-github-action/docker-build-ros2-pkg

## Usage

``` yaml
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
      - name: Build and push
        uses: TRAPS-RoboCup/traps-github-action/docker-build-ros2-pkg@main
        with:
          token: $${{ github.token }}
          # token: $${{ secrets.PAT }} # if you use private repos
          # package-path: ${{ github.event.repository.name }}
          # repos-file: *.repos
          platforms: linux/amd64, linux/arm64/v8
          # build-options: "--executor sequential --cmake-args -DCMAKE_BUILD_TYPE=Release"
          push: ${{ github.event_name != 'pull_request' }}
          rosdistro: humble
```
