#!/bin/bash

set -e  # Exit on error

PROJECT_NAME="pureblue"
REMOTE_PREFIX="ghcr.io/pureblue-os/$PROJECT_NAME"

BUILD_DIR="build"
BUILDING=()
PUBLISH=false

./chmod-x-all.sh

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case "$1" in
        --publish)
            PUBLISH=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

get_local_image_name() {
    local IMAGE_NAME="$1"
    echo "${PROJECT_NAME}-local-${IMAGE_NAME}"
}

get_remote_image_name() {
    local IMAGE_NAME="$1"
    local REMOTE_IMAGE_NAME="$REMOTE_PREFIX"
    [[ "$IMAGE_NAME" != "base" ]] && REMOTE_IMAGE_NAME+="-$IMAGE_NAME"
    echo "$REMOTE_IMAGE_NAME"
}

build_image() {
    local IMAGE_NAME="$1"
    local LOCAL_IMAGE_NAME="$(get_local_image_name "$IMAGE_NAME")"
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
    podman build --tag "$LOCAL_IMAGE_NAME" -f "$IMAGE_DIR"/Containerfile .

    BUILDING=( "${BUILDING[@]/$IMAGE_NAME}" )
}

publish_image() {
    local IMAGE_NAME="$1"
    local LOCAL_IMAGE_NAME="$(get_local_image_name "$IMAGE_NAME")"
    local REMOTE_IMAGE_NAME="$(get_remote_image_name "$IMAGE_NAME")"

    local IMAGE_DIR="$BUILD_DIR/$IMAGE_NAME"
    
    if [[ -f "$IMAGE_DIR/tags" ]]; then
        TAGS=$(bash "$IMAGE_DIR/tags")
        
        while IFS= read -r TAG || [[ -n "$TAG" ]]; do
            echo "Tagging and pushing $IMAGE_NAME as $REMOTE_IMAGE_NAME:$TAG..."
            podman tag "$LOCAL_IMAGE_NAME" "$REMOTE_IMAGE_NAME:$TAG"
            podman push "$REMOTE_IMAGE_NAME:$TAG"
        done <<< "$TAGS"
    fi
}


IMAGES=($(ls -d $BUILD_DIR/*/ | xargs -n 1 basename))
for IMAGE in "${IMAGES[@]}"; do
    build_image "$IMAGE"
done

if $PUBLISH; then
    for IMAGE in "${IMAGES[@]}"; do
        publish_image "$IMAGE"
    done
else
    echo "Publishing disabled. Skipping publish step."
fi
