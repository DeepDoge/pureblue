FROM quay.io/fedora-ostree-desktops/silverblue:41

ARG BUILD
COPY build /etc/pureblue

RUN bash -c 'set -euxo pipefail && \
    /etc/pureblue/${BUILD}/build.sh && \
    rm -rf /tmp/* /var/* && \
    ostree container commit'
