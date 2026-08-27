FROM amazonlinux:2023

ENV container=docker

RUN dnf install -y systemd curl \
 && dnf clean all

RUN printf '#!/bin/sh\nexit 0\n' > /usr/local/bin/systemctl \
 && chmod +x /usr/local/bin/systemctl \
 && curl -fsSL https://github.com/saltstack/salt-bootstrap/releases/latest/download/bootstrap-salt.sh \
    | sh -s -- -X stable \
 && rm /usr/local/bin/systemctl \
 && rm -rf /var/cache/salt \
 && ln -sf /dev/null /etc/systemd/system/salt-minion.service

CMD ["/usr/lib/systemd/systemd"]
