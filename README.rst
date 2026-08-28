======
Unbound
======

A Salt formula to install and configure the `Unbound <https://nlnetlabs.nl/projects/unbound/>`_
recursive DNS resolver.

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

.. contents:: **Table of Contents**
    :depth: 1

Requirements
============

- **Salt** >= 3006 (tested on 3006+)
- **Python** >= 3.6 (Salt dependency)
- For integration testing: **Ruby** >= 3.0, **Bundler**, **Docker**

Installation
============

Option 1: GitFS
---------------

Add the formula to your Salt master ``/etc/salt/master``:

.. code-block:: yaml

    fileserver_backend:
      - gitfs
      - roots

    gitfs_remotes:
      - https://github.com/SomeBlackMagic/salt-unbound-formula.git

Option 2: Local clone
---------------------

Clone the repository into your ``file_roots``:

.. code-block:: bash

    git clone https://github.com/SomeBlackMagic/salt-unbound-formula.git /srv/salt/unbound-formula

Then symlink (or add ``/srv/salt/unbound-formula`` to ``file_roots``) so the ``unbound`` directory
is reachable as ``salt://unbound``.

Option 3: Salt Shaker / formula dependency manager
---------------------------------------------------

Follow the conventions of your chosen formula manager and point it at this repository.

Available States
================

.. contents::
    :local:

``unbound``
-----------

Meta-state. Installs the unbound package, deploys configuration, and ensures
the service is running.

``unbound.install``
-------------------

Installs the ``unbound`` package and downloads the DNS root hints file
(``named.cache``) from ``https://www.internic.net/domain/named.cache``.

``unbound.config``
------------------

Manages ``/etc/unbound/unbound.conf`` (path varies by OS) using Pillar data
and the ``map.jinja`` lookup table.

``unbound.service``
-------------------

Ensures the ``unbound`` service is enabled and running. On Debian/Ubuntu,
also manages ``/etc/default/unbound``.

Supported Platforms
===================

The following platforms are actively tested via Test Kitchen (see `Testing`_):

+----------------------+---------------------------+
| Platform             | Image                     |
+======================+===========================+
| Debian 12            | debian-12                 |
+----------------------+---------------------------+
| Ubuntu 22.04         | ubuntu-2204               |
+----------------------+---------------------------+
| Ubuntu 24.04         | ubuntu-2404               |
+----------------------+---------------------------+
| Rocky Linux 9        | rockylinux-9              |
+----------------------+---------------------------+
| AlmaLinux 9          | almalinux-9               |
+----------------------+---------------------------+
| CentOS Stream 9      | centos-stream-9           |
+----------------------+---------------------------+
| Amazon Linux 2023    | amazonlinux-2023          |
+----------------------+---------------------------+
| openSUSE Leap 15     | opensuse-leap-15          |
+----------------------+---------------------------+

The following platforms are supported by the OS map but not currently included
in the automated test suite:

+------------------+-----------------------+
| OS Family        | Examples              |
+==================+=======================+
| FreeBSD          | FreeBSD               |
+------------------+-----------------------+
| Arch             | Arch Linux            |
+------------------+-----------------------+
| Gentoo           | Gentoo                |
+------------------+-----------------------+
| OpenBSD          | OpenBSD               |
+------------------+-----------------------+

Configuration
=============

This formula is configured via Salt Pillar. Copy ``pillar.example`` to your
Pillar tree and adjust as needed.

All options are nested under the ``unbound`` key. Lookup overrides (package
name, file paths) go under ``unbound:lookup``.

Minimal Example
---------------

.. code-block:: yaml

    unbound:
      server:
        interfaces:
          - 127.0.0.1
          - ::1
        acls:
          - 127.0.0.0/8 allow
          - 10.0.0.0/8 allow
      forwardzones:
        - zonename: "."
          options:
            - key: forward-addr
              value: 9.9.9.9

Stub Zones
----------

Stub zones forward queries for a specific domain to an authoritative name server:

.. code-block:: yaml

    unbound:
      stubzones:
        - zonename: example.lan
          options:
            - key: stub-addr
              value: 192.168.1.1
            - key: stub-addr
              value: 192.168.1.2

DNSSEC and Private Domains
--------------------------

.. code-block:: yaml

    unbound:
      server:
        # Disable DNSSEC validation for these domains
        domains_insecure:
          - example.lan

        # Allow private address responses for these domains
        private_domains:
          - example.lan

        # Block rebinding attacks — these addresses are treated as private
        private_addresses:
          - 10.0.0.0/8
          - 172.16.0.0/12
          - 192.168.0.0/16
          - 169.254.0.0/16
          - fd00::/8
          - fe80::/10

        # Local zone declarations
        local_zones:
          - example.lan static

Remote Control
--------------

.. code-block:: yaml

    unbound:
      remote:
        options:
          - key: control-enable
            value: "yes"
          - key: control-interface
            value: 127.0.0.1

Generic Server Options
----------------------

Any ``unbound.conf`` ``server:`` directive can be passed as a key/value pair:

.. code-block:: yaml

    unbound:
      server:
        options:
          - key: verbosity
            value: 1
          - key: use-syslog
            value: "yes"
          - key: hide-identity
            value: "yes"
          - key: hide-version
            value: "yes"
          - key: harden-glue
            value: "yes"
          - key: harden-dnssec-stripped
            value: "yes"
          - key: use-caps-for-id
            value: "yes"
          - key: num-threads
            value: 4
          - key: rrset-cache-size
            value: 256m
          - key: msg-cache-size
            value: 128m

Override OS Defaults
--------------------

Override any lookup value (package name, file paths, etc.):

.. code-block:: yaml

    unbound:
      lookup:
        config_file: /usr/local/etc/unbound/unbound.conf
        cache_file: /usr/local/etc/unbound/named.cache

See ``pillar.example`` for the full list of available options with comments.

Pillar Reference
================

``unbound:lookup``
------------------

+------------------+------------------------+-------------------------------------+
| Key              | Default (Debian)       | Description                         |
+==================+========================+=====================================+
| package          | unbound                | Package name to install             |
+------------------+------------------------+-------------------------------------+
| service          | unbound                | Service name                        |
+------------------+------------------------+-------------------------------------+
| config_file      | /etc/unbound/unbound.conf | Path to main config file         |
+------------------+------------------------+-------------------------------------+
| cache_file       | /etc/unbound/named.cache  | Path for root hints file         |
+------------------+------------------------+-------------------------------------+
| config_group     | root                   | Group owner of the config file      |
+------------------+------------------------+-------------------------------------+
| defaults_file    | /etc/default/unbound   | Debian/Ubuntu only: defaults file   |
+------------------+------------------------+-------------------------------------+

``unbound:server``
------------------

+---------------------+----------------------------------+--------------------------------------------+
| Key                 | Type                             | Description                                |
+=====================+==================================+============================================+
| interfaces          | list of strings                  | Addresses to listen on                     |
+---------------------+----------------------------------+--------------------------------------------+
| acls                | list of strings                  | Access control rules (CIDR + action)       |
+---------------------+----------------------------------+--------------------------------------------+
| options             | list of ``{key, value}`` maps    | Raw server: directives                     |
+---------------------+----------------------------------+--------------------------------------------+
| domains_insecure    | list of strings                  | Domains exempt from DNSSEC validation      |
+---------------------+----------------------------------+--------------------------------------------+
| private_domains     | list of strings                  | Domains allowed to return private IPs      |
+---------------------+----------------------------------+--------------------------------------------+
| private_addresses   | list of strings                  | CIDR ranges treated as private             |
+---------------------+----------------------------------+--------------------------------------------+
| local_zones         | list of strings                  | Local zone declarations                    |
+---------------------+----------------------------------+--------------------------------------------+

``unbound:stubzones`` / ``unbound:forwardzones``
------------------------------------------------

Both accept a list of zone definitions:

.. code-block:: yaml

    - zonename: <string>        # required
      options:
        - key: <string>
          value: <string>

``unbound:remote``
------------------

.. code-block:: yaml

    remote:
      options:
        - key: control-enable
          value: "yes"

Testing
=======

This formula uses `Test Kitchen <https://kitchen.ci/>`_ with the
`kitchen-salt <https://github.com/saltstack/kitchen-salt>`_ provisioner and
`InSpec <https://www.inspec.io/>`_ for verification.

Prerequisites
-------------

Install Ruby gem dependencies:

.. code-block:: bash

    make install
    # equivalent to: bundle config set --local path vendor/bundle && bundle install

Available make targets
----------------------

.. code-block:: bash

    make list                        # list all Kitchen instances
    make test                        # full test cycle (converge + verify + destroy) for all platforms
    make converge                    # converge all platforms
    make verify                      # verify all platforms
    make destroy                     # destroy all instances

    # Per-platform targets
    make test-debian-12
    make test-ubuntu-2204
    make test-ubuntu-2404
    make test-rockylinux-9
    make test-amazonlinux-2023

    # Open a shell in a running instance
    make login PLATFORM=debian-12

Using kitchen directly
----------------------

.. code-block:: bash

    bundle exec kitchen list
    bundle exec kitchen test default-debian-12
    bundle exec kitchen converge default-ubuntu-2404
    bundle exec kitchen verify default-rockylinux-9
    bundle exec kitchen login default-debian-12

Validate syntax (Jinja + YAML + state structure):

.. code-block:: bash

    salt '*' state.show_sls unbound

Apply the formula:

.. code-block:: bash

    salt '*' state.apply unbound

Dry-run mode:

.. code-block:: bash

    salt '*' state.apply unbound test=True

Contributing
============

1. Fork the repository on GitHub.
2. Create a feature branch from ``master``.
3. Add or update tests in ``test/integration/default/controls/``.
4. Run ``make test`` locally against the affected platforms.
5. Submit a pull request with a clear description of the change.

Please keep changes focused — one logical change per PR. Update ``CHANGELOG.rst``
for any user-visible change.

License
=======

See `LICENSE <LICENSE>`_.
