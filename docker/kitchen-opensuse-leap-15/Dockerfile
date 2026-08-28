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

RUN zypper --non-interactive install --no-recommends \
      ruby ruby-devel git \
 && zypper clean --all \
 && mkdir -p /opt/chef/embedded/bin \
 && ln -sf "$(which ruby)" /opt/chef/embedded/bin/ruby \
 && ln -sf "$(which gem)" /opt/chef/embedded/bin/gem

CMD ["/usr/lib/systemd/systemd"]
