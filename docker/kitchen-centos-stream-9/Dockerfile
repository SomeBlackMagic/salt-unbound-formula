FROM quay.io/centos/centos:stream9

RUN dnf install -y --allowerasing systemd curl \
 && dnf clean all

RUN touch /tmp/disable_salt_checks \
 && curl -fsSL https://github.com/saltstack/salt-bootstrap/releases/latest/download/bootstrap-salt.sh \
    | sh -s -- -X stable \
 && rm -rf /var/cache/salt

CMD ["/usr/lib/systemd/systemd"]
