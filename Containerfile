FROM quay.io/fedora-ostree-desktops/silverblue:41

ARG SETUP_SCRIPT
COPY /scripts /tmp/scripts
WORKDIR /tmp/scripts

RUN chmod +x ./${SETUP_SCRIPT}.sh && \
    ./${SETUP_SCRIPT}.sh && \
    rm -rf /tmp/* /var/* && \
    ostree container commit
