FROM phusion/baseimage:master

# Installing

RUN echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_20.04/ /" | tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
RUN curl -L "https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_20.04/Release.key" | apt-key add -

RUN apt-get update -y && \
    apt install -y --fix-missing podman fuse-overlayfs sudo && \
    rm -rf /var/lib/apt/lists

# Podman setup

RUN useradd -m -s /bin/bash user && usermod -aG sudo user && echo user:password | chpasswd; \
    echo -e "user:1:999\nuser:1001:10000" > /etc/subuid; \
    echo -e "user:1:999\nuser:1001:10000" > /etc/subgid;

ADD https://raw.githubusercontent.com/containers/podman/main/contrib/podmanimage/stable/containers.conf /etc/containers/containers.conf
ADD https://raw.githubusercontent.com/containers/podman/main/contrib/podmanimage/stable/podman-containers.conf /home/user/.config/containers/containers.conf

RUN mkdir -p /home/user/.local/share/containers; chown user:user -R /home/user

RUN chmod 644 /etc/containers/containers.conf; sed -i -e 's|^#mount_program|mount_program|g' -e '/additionalimage.*/a "/var/lib/shared",' -e 's|^mountopt[[:space:]]*=.*$|mountopt = "nodev,fsync=0"|g' /etc/containers/storage.conf
RUN mkdir -p /var/lib/shared/overlay-images /var/lib/shared/overlay-layers /var/lib/shared/vfs-images /var/lib/shared/vfs-layers; touch /var/lib/shared/overlay-images/images.lock; touch /var/lib/shared/overlay-layers/layers.lock; touch /var/lib/shared/vfs-images/images.lock; touch /var/lib/shared/vfs-layers/layers.lock

ENV _CONTAINERS_USERNS_CONFIGURED=""

RUN apt-get update -y && \
    apt install -y --fix-missing python3-pip && \
    runuser -l user -c "pip3 install podman-compose" && \
    apt autoremove -y python3-pip && \
    rm -rf /var/lib/apt/lists

RUN echo "alias docker=podman" >> /home/user/.bashrc; \
    echo "alias docker-compose=podman-compose" >> /home/user/.bashrc; \
    echo 'export PATH=$PATH:/home/user/.local/bin' >> /home/user/.bashrc

VOLUME /var/lib/containers
VOLUME /home/user/.local/share/containers

# SSH setup (optional)

COPY key.pub /tmp/key.pub
RUN mkdir -p /home/user/.ssh && cat /tmp/key.pub >> /home/user/.ssh/authorized_keys

COPY startup.sh /etc/my_init.d/startup.sh
RUN chmod +x /etc/my_init.d/startup.sh

RUN rm -f /etc/service/sshd/down

# Volume: /data

VOLUME /data

CMD ["/sbin/my_init"]
