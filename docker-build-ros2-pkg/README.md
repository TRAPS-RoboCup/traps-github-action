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
    steps:
      - name: Clone packages to src
        uses: TRAPS-RoboCup/traps-github-action/clone-packages-to-src@main
        # with:
        #   token: ${{ github.token }}
        #   repos-file: "*.repos"

      - name: Add .dockerignore
        uses: TRAPS-RoboCup/traps-github-action/add-ros2-docker-ignore@main
        # with:
        #   working-directory: "${{ github.workspace }}"

      - name: Build and push
        uses: TRAPS-RoboCup/traps-github-action/docker-build-ros2-pkg@main
        with:
          target: executor # builder, build-cache, test-cache
          push: true
          # token: ${{ github.token }}
```
