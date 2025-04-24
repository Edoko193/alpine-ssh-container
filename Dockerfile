FROM alpine:latest
# Your desired username and super secure password
ENV USERNAME="ed"
ENV PASSWORD="password"

RUN apk update && apk upgrade && apk add openssh openrc bash

# For faster ssh connection
RUN echo "UseDNS no" >> /etc/ssh/sshd_config.d/20-dont_use_dns.conf

# Adding ssh user
RUN adduser -h /home/$USERNAME -s /bin/bash -u 1000 -D $USERNAME
RUN echo "PermitRootLogin no" >> /etc/ssh/sshd_config.d/20-deny_root.conf
RUN echo "AllowUsers $USERNAME" >> /etc/ssh/sshd_config.d/20-allow_users.conf
RUN echo "$USERNAME:$PASSWORD" | chpasswd

# touch command is For running openrc in container so we can use our init system. First command returns error, in order to continue I added `|| true` to Dockerfile
# Why openrc instead of starting normally? Because if you check alpine's openssh openrc script they do a little bit hardening and I like that.
RUN rc-update add sshd && rc-status && rc-service sshd start || true

# Optional: giving doas(sudo) perms to user
RUN apk add doas
RUN echo "permit persist :wheel" >> /etc/doas.d/doas.conf
RUN adduser $USERNAME wheel

COPY ./start_ssh.sh /usr/sbin
RUN chmod +x /usr/sbin/start_ssh.sh

# Script runs /bin/bash. If you dont want it remove it as you need
ENTRYPOINT ["/usr/sbin/start_ssh.sh"]
