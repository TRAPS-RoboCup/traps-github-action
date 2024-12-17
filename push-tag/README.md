# traps-github-action/ros2-add-tag

## Usage

``` push-tag.yaml
name: Push tag

run-name: Push tag:${{ github.ref_name }}(${{ github.event.head_commit.message }})

on:
  push:
    branches:
      - 'main'

jobs:
  add-tag:
    runs-on: ubuntu-22.04

    permissions:
      contents: write

    steps:
      - name: Push tag
        uses: ./.traps-github-action/push-tag

```
