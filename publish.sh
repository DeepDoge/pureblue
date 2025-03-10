#!/bin/bash

set -e  # Exit on error

REMOTE_PREFIX="ghcr.io/pureblue-os/pureblue"

FEDORA_VERSION=41
DEFAULT_TAGS=(
    "latest"
    "$FEDORA_VERSION"
)

BUILD_DIR="build"
BUILDING=()
PUBLISH=false

./chmod-x-all.sh

get_image_name() {
    local IMAGE_NAME="$1"
    local REMOTE_IMAGE_NAME="$REMOTE_PREFIX"
    [[ "$IMAGE_NAME" != "base" ]] && REMOTE_IMAGE_NAME+="-$IMAGE_NAME"
    echo "$REMOTE_IMAGE_NAME"
}

publish_image() {
    local IMAGE_NAME="$1"
    local REMOTE_IMAGE_NAME="$(get_image_name "$IMAGE_NAME")"
    local IMAGE_DIR="$BUILD_DIR/$IMAGE_NAME"
    
    # Initialize TAGS as an empty array
    TAGS=()

    # Read the tags file into the TAGS array
    if [[ -f "$IMAGE_DIR/tags" ]]; then
        while IFS= read -r TAG || [[ -n "$TAG" ]]; do
            TAGS+=("$TAG")
        done < "$IMAGE_DIR/tags"
    fi

    # Append the default tags to the TAGS array
    TAGS+=("${DEFAULT_TAGS[@]}")

    # Now TAGS is an array, loop through it
    for TAG in "${TAGS[@]}"; do
        echo "Pushing $IMAGE_NAME as $REMOTE_IMAGE_NAME:$TAG..."
        podman tag $REMOTE_IMAGE_NAME "$REMOTE_IMAGE_NAME:$TAG"
        podman push "$REMOTE_IMAGE_NAME:$TAG"
    done
}

build_image() {
    local IMAGE_NAME="$1"
    local REMOTE_IMAGE_NAME="$(get_image_name "$IMAGE_NAME")"
    local IMAGE_DIR="$BUILD_DIR/$IMAGE_NAME"

    if [[ " ${BUILDING[@]} " =~ " $IMAGE_NAME " ]]; then
        echo "Error: Detected circular dependency or duplicate build: $IMAGE_NAME"
        exit 1
    fi

    BUILDING+=("$IMAGE_NAME")

    if [[ -f "$IMAGE_DIR/deps" ]]; then
        while IFS= read -r DEP || [[ -n "$DEP" ]]; do
            build_image "$DEP"
        done < "$IMAGE_DIR/deps"
    fi

    echo "Building $IMAGE_NAME..."
    podman build --tag "$REMOTE_IMAGE_NAME" -f "$IMAGE_DIR/Containerfile" ./build --build-arg FEDORA_VERSION=$FEDORA_VERSION

    publish_image "$IMAGE"

    BUILDING=( "${BUILDING[@]/$IMAGE_NAME}" )
}

IMAGES=($(ls -d $BUILD_DIR/*/ | xargs -n 1 basename))
for IMAGE in "${IMAGES[@]}"; do
    build_image "$IMAGE"
done
