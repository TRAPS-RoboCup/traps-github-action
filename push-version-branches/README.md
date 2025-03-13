# traps-github-action/push-version-branches

## Usage

``` push-version-branches.yaml
name: Push version branches

run-name: Push version branches:${{ github.ref_name }}(${{ github.event.head_commit.message }})

on:
  push:
    tags: 'v*.*.*'

jobs:
  push-tag:
    runs-on: ubuntu-22.04

    # permissions: # Required when using github.token
    #   contents: write
    #   actions: write

    steps:
      - name: Push version branches
        uses: TRAPS-RoboCup/traps-github-action/push-version-branches@main
        # with:
        #   checkout: true
        #   # token: ${{ github.token }} # If you do not change workflow
        #   token: ${{ secrets.PAT }} # Maybe you need this
        #   tag: ${GITHUB_REF#refs/*/}

```
