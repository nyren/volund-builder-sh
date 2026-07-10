#!/bin/bash
# ex: sw=4 expandtab
set -e

. volund/lib/core
. volund/lib/version
. volund/lib/opinionated

IMAGE_REGISTRY=ghcr.io/nyren
IMAGE_REPO_PATHS[dev]=volund-dev
IMAGE_REPO_PATHS[ci]=volund-ci
IMAGE_REPO_PATHS[rc]=volund-rc
IMAGE_REPO_PATHS[release]=volund-release

IMAGES[main]="volund-builder-sh"

IMAGE_BASE="mirror.gcr.io/library/alpine:3.24.1"
IMAGE_PACKAGES="
    bash
    coreutils
    curl
    findutils
    gawk
    git
    grep
    gzip
    less
    sed
    tar
"

volund_default "clean init build verify publish"

clean() {
    volund_msg "==> clean"
    volund_clean
}

init() {
    volund_msg "==> init"
    set_version_dev
    set_repo_dev
}

build() {
    volund_msg "==> build"
    volund_runtime build \
        -t "$v_main_image_ref" \
        -f Containerfile \
        --build-arg "IMAGE_BASE=${IMAGE_BASE}" \
        --build-arg "PACKAGES=$IMAGE_PACKAGES" \
        .
}

verify() {
    volund_msg "==> verify"

    # Add alias for the newly created builder image
    volund_image builder "$v_main_image_ref"

    # Verify some builder commands
    volund_cmd builder sh -c 'awk --version | grep -qE "^GNU Awk"' || \
        volund_error "GNU Awk not installed"
    volund_cmd builder sh -c 'find --version | grep -qE "GNU findutils"' || \
        volund_error "GNU findutils not installed"
}

publish() {
    volund_msg "==> publish"
    volund_runtime push "$v_main_image_ref"
    echo "$v_main_image_ref"
}

volund_main "$@"
