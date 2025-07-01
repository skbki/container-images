FROM ubuntu:24.04

# Set environment variables for non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive

# Install systemd and other required packages
RUN \
    apt update -y && \
    apt install -y \
        systemd \
        systemd-sysv \
        apt-utils \
        gcc \
        git \
        python3 \
        python3-dev \
        python3-pip \
        libssl-dev \
        sudo \
        dbus \
        && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    rm -rf /var/lib/apt/lists/*

# Configure systemd
# Remove unnecessary systemd services
RUN \
    cd /lib/systemd/system/sysinit.target.wants/ && \
    ls | grep -v systemd-tmpfiles-setup | xargs rm -f $1 && \
    rm -f /lib/systemd/system/multi-user.target.wants/* && \
    rm -f /etc/systemd/system/*.wants/* && \
    rm -f /lib/systemd/system/local-fs.target.wants/* && \
    rm -f /lib/systemd/system/sockets.target.wants/*udev* && \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl* && \
    rm -f /lib/systemd/system/basic.target.wants/* && \
    rm -f /lib/systemd/system/anaconda.target.wants/* && \
    rm -f /lib/systemd/system/plymouth* && \
    rm -f /lib/systemd/system/systemd-update-utmp*

# Create a fake machine-id
RUN systemd-machine-id-setup

# Set environment
ENV SHELL=/bin/bash
ENV container=docker

# Set systemd as the init system
VOLUME ["/sys/fs/cgroup"]
STOPSIGNAL SIGRTMIN+3
CMD ["/lib/systemd/systemd"]
