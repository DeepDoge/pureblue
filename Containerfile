FROM quay.io/fedora-ostree-desktops/silverblue:41

ARG BUILD
COPY build /pureblue

RUN set -euxo pipefail && \
    cd /pureblue/${BUILD} && \
    ./setup.sh && \
    rm -rf /tmp/* /var/* && \
    ostree container commit