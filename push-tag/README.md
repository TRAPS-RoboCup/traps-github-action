# traps-github-action/ros2-add-tag

## Usage

``` push-tag.yaml
name: push-tag
description: Read version from package.xml and push tag to the repository

inputs:
  checkout:
    description: First decide whether to check or not
    required: false
    default: true
  path:
    description: Package path
    required: false
    default: .

  token:
    description: TOKEN used to push Docker Image
    required: false
    default: ${{ github.token }}

runs:
  using: composite
  steps:
    - name: Checkout
      if: ${{ inputs.checkout }}
      uses: actions/checkout@v4
      with:
        path: ${{ inputs.path }}
        token: ${{ inputs.token }}
        fetch-tags: true

    - name: Install xmmlint
      run: sudo apt update && sudo apt install -y libxml2-utils
      shell: bash

    - name: Push the tag if it does not exist
      working-directory: ${{ inputs.path }}
      run: |
        git config --local user.email $(xmllint --xpath 'string(/package/maintainer/@email)' package.xml)
        git config --local user.name $(xmllint --xpath 'string(/package/maintainer)' package.xml)
        PACKAGE_VERSION=v$(xmllint --xpath "string(/package/version)" "package.xml")
        if ! git tag | grep ${PACKAGE_VERSION} > /dev/null
        then
          git tag -a ${PACKAGE_VERSION} -m "$(git log -1 --pretty=%B)"
          git push origin ${PACKAGE_VERSION}
        fi
      shell: bash

```
