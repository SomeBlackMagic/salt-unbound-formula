FROM amazonlinux:2023

ENV container=docker

RUN dnf install -y systemd curl \
 && dnf clean all

RUN curl -fsSL https://github.com/saltstack/salt-bootstrap/releases/latest/download/bootstrap-salt.sh \
    | sh -s -- -X stable \
 && rm -rf /var/cache/salt \
 && ln -sf /dev/null /etc/systemd/system/salt-minion.service

CMD ["/usr/lib/systemd/systemd"]
