FROM quay.io/fedora-ostree-desktops/silverblue:41

ARG BUILD
# Not Using /etc so its not persistent across deployments.
COPY build /opt/pureblue

RUN bash -c 'set -euxo pipefail && \
    /opt/pureblue/${BUILD}/build.sh && \
    rm -rf /tmp/* /var/* && \
    ostree container commit'
