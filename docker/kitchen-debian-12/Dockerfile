FROM debian:12

ENV container=docker \
    DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      systemd-sysv \
      curl \
      ca-certificates \
 && rm -rf /var/lib/apt/lists/*

RUN printf '#!/bin/sh\nexit 0\n' > /usr/local/bin/systemctl \
 && chmod +x /usr/local/bin/systemctl \
 && curl -fsSL https://github.com/saltstack/salt-bootstrap/releases/latest/download/bootstrap-salt.sh \
    | sh -s -- -X stable \
 && rm /usr/local/bin/systemctl \
 && rm -rf /var/cache/salt \
 && ln -sf /dev/null /etc/systemd/system/salt-minion.service

CMD ["/lib/systemd/systemd"]
