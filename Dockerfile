FROM centos:centos7

LABEL maintainer="Dimitri Tarassenko <mitka@mitka.us>"

ENV container=docker

# Systemd - specific stuff
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
    systemd-tmpfiles-setup.service ] || rm -f $i; done); \
    rm -f /lib/systemd/system/multi-user.target.wants/*;\
    rm -f /etc/systemd/system/*.wants/*;\
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*;\
    rm -f /lib/systemd/system/anaconda.target.wants/*;

ADD nimble.repo /etc/yum.repos.d/nimble.repo

# Some debug stuff
RUN yum -y install initscripts nimble nimble-srt
RUN yum -y install mc

# Tune-ups, clean up
RUN ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime

# Ensure the termination happens on container stop, cgroup, starting init
STOPSIGNAL SIGRTMIN+3
VOLUME ["/sys/fs/cgroup"]
CMD ["/usr/sbin/init"]
