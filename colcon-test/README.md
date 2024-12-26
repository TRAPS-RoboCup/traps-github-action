# traps-github-action/ros2-add-tag

## Usage

### only this package

``` colcon-test-only-this.yaml
name: Test

run-name: Test:${{ github.ref_name }}(${{ github.event.head_commit.message }})

on:
  push:
  pull_request:

jobs:
  test:
    runs-on: ubuntu-22.04

    permissions:
      contents: write

    container:
      image: ros:humble-ros-base

      - name: Colcon Test
        uses: TRAPS-RoboCup/traps-github-action/colcon-test@main
        with:
          workspace-path: ./ros2_ws
```

### with others package

``` colcon-test-with-others.yaml
name: Test

run-name: Test:${{ github.ref_name }}(${{ github.event.head_commit.message }})

on:
  push:
  pull_request:

jobs:
  test:
    runs-on: ubuntu-22.04

    permissions:
      contents: write

    container:
      image: ros:humble-ros-base

    steps:
      - name: Checkout other-repository
        uses: actions/checkout@v4
        with:
          path: ./ros2_ws/src/other_package
          repository: other-organization/other-repository
          token: ${{ secrets.PAT }} # if you need

      - name: Colcon Test
        uses: TRAPS-RoboCup/traps-github-action/colcon-test@main
        with:
          workspace-path: ./ros2_ws
```

### work space
``` colcon-test-with-others.yaml
name: Test

run-name: Test:${{ github.ref_name }}(${{ github.event.head_commit.message }})

on:
  push:
  pull_request:

jobs:
  test:
    runs-on: ubuntu-22.04

    permissions:
      contents: write

    container:
      image: ros:humble-ros-base

    steps:
      - name: Checkout
        uses: actions/checkout@v4
        with:
          submodules: true
          token: ${{ secrets.PAT }} # if you need

      - name: Colcon Test
        uses: TRAPS-RoboCup/traps-github-action/colcon-test@main
        with:
          workspace-path: .
          checkout false
```
