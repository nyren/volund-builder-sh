#!/bin/bash
# ex: sw=4 expandtab
set -e

. volund/lib/core
. volund/lib/tools
. volund/lib/microservice

DEFAULT_REGISTRY=ghcr.io/nyren
DEFAULT_REPO_PATH_DEV=volund-dev
DEFAULT_REPO_PATH_CI=volund-ci
DEFAULT_REPO_PATH_RC=volund-rc
DEFAULT_REPO_PATH_RELEASE=volund-release

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
    shellcheck
    tar
"

volund_default "clean init build verify publish"

clean() {
    volund_clean
}

init() {
    set_version_dev
    set_repo_dev
}

build() {
    volund_runtime build \
        ${NO_CACHE:+--no-cache} \
        -t "$v_main_image_ref" \
        -f Containerfile \
        --build-arg "IMAGE_BASE=${IMAGE_BASE}" \
        --build-arg "PACKAGES=$IMAGE_PACKAGES" \
        .
}

verify() {
    # Add alias for the newly created builder image
    volund_image builder "$v_main_image_ref"

    # Verify some builder commands
    volund_cmd builder sh -c 'awk --version | grep -qE "^GNU Awk"' || \
        volund_error "GNU Awk not installed"
    volund_cmd builder sh -c 'find --version | grep -qE "GNU findutils"' || \
        volund_error "GNU findutils not installed"
}

publish() {
    publish_images
    volund_msg $(volund_color bold yellow "$v_main_image_ref")
}

volund_main "$@"
