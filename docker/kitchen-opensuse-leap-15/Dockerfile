FROM opensuse/leap:15

RUN zypper --non-interactive install --no-recommends \
      systemd \
      curl \
      ca-certificates \
 && zypper clean --all

RUN touch /tmp/disable_salt_checks \
 && curl -fsSL https://github.com/saltstack/salt-bootstrap/releases/latest/download/bootstrap-salt.sh \
    | sh -s -- -X stable \
 && rm -rf /var/cache/salt

RUN curl -fsSL https://raw.githubusercontent.com/saltstack/kitchen-salt/master/assets/install.sh \
    | sh

CMD ["/usr/lib/systemd/systemd"]
