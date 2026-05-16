# traps-github-action/clone-packages-to-src

## Usage

``` yaml
name: Clone packages to src

run-name: Clone packages to src:${{ github.ref_name }}(${{ github.event.head_commit.message }})

on:
  push:
  pull_request:

jobs:
  clone:
    runs-on: ubuntu-22.04

    permissions:
      contents: read

    steps:
      - name: Clone packages to src
        uses: TRAPS-RoboCup/traps-github-action/clone-packages-to-src@main
        # with:
        #   token: ${{ github.token }}
        #   repos-file: "*.repos"
```
