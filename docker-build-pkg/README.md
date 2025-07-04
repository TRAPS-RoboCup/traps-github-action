# traps-github-action/docker-build-pkg

## Usage

``` yaml
name: Docker Build Package

run-name: Docker Build Package:${{ github.ref_name }}(${{ github.event.head_commit.message }})

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
        uses: TRAPS-RoboCup/traps-github-action/docker-build-pkg@main
        # with:
        #   token: ${{ github.token }}
        #   package-path: ${{ github.event.repository.name }}
        #   repos-file: "*.repos"
        #   platforms: linux/amd64, linux/arm64/v8
        #   builder-base-image: ubuntu:latest
        #   executor-base-image: ubuntu:latest
        #   build-depends-install-script: >
        #     apt-get update &&
        #     apt-get install -y --no-install-recommends ...  &&
        #     apt-get clean && rm -rf /var/lib/apt/lists/*
        #   pre-build-script: ""
        #   build-options: "--executor sequential --cmake-args -DCMAKE-BUILD-TYPE=Release"
        #   post-build-script: ""
        #   exec-depends-install-script: >
        #     apt-get update &&
        #     apt-get install -y --no-install-recommends ...  &&
        #     apt-get clean && rm -rf /var/lib/apt/lists/*
        #   push: true
        #   test: true
```
