# traps-github-action/add-ros2-docker-ignore

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
      contents: read

    steps:
      - name: Add .dockerignore
        uses: TRAPS-RoboCup/traps-github-action/add-ros2-docker-ignore@main
        # with:
        #   working-directory: "${{ github.workspace }}"
```

## What it does

Appends the following entries to `.dockerignore` in the specified workspace:

- `doc`
- `.*`
- `README.md`
