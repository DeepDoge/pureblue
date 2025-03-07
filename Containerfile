FROM quay.io/fedora-ostree-desktops/silverblue:41

ARG BUILD
COPY build /etc/pureblue

RUN set -euxo pipefail && \
    /etc/pureblue/${BUILD}/setup.sh && \
    rm -rf /tmp/* /var/* && \
    ostree container commit