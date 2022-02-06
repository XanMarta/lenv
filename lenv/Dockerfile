FROM phusion/baseimage:master

RUN mkdir -p /etc/my_init.d

COPY startup.sh /etc/my_init.d/startup.sh

RUN chmod +x /etc/my_init.d/startup.sh

# SSH

COPY key.pub /tmp/key.pub

RUN cat /tmp/key.pub >> /root/.ssh/authorized_keys

RUN rm -f /etc/service/sshd/down

CMD ["/sbin/my_init"]
