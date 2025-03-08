FROM quay.io/fedora-ostree-desktops/silverblue:41

ARG BUILD
COPY build /usr/local/share/pureblue

RUN bash -c '/usr/local/share/pureblue/${BUILD}/build.sh && \
    rm -rf /tmp/* /var/* && \
    ostree container commit'
