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

General Notes
=============

See the full `Salt Formulas installation and usage instructions
<http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_ on the
SaltStack website.

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

+------------------+-----------------+
| OS Family        | Tested On       |
+==================+=================+
| Debian           | Debian, Ubuntu  |
+------------------+-----------------+
| RedHat           | CentOS, RHEL    |
+------------------+-----------------+
| FreeBSD          | FreeBSD         |
+------------------+-----------------+
| Arch             | Arch Linux      |
+------------------+-----------------+
| Gentoo           | Gentoo          |
+------------------+-----------------+
| OpenBSD          | OpenBSD         |
+------------------+-----------------+
| Suse             | openSUSE, SLES  |
+------------------+-----------------+

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

.. code-block:: yaml

    unbound:
      stubzones:
        - zonename: example.lan
          options:
            - key: stub-addr
              value: 192.168.1.1

Override OS Defaults
--------------------

.. code-block:: yaml

    unbound:
      lookup:
        config_file: /usr/local/etc/unbound/unbound.conf
        cache_file: /usr/local/etc/unbound/named.cache

See ``pillar.example`` for the full list of available options with comments.

Testing
=======

Validate syntax (Jinja + YAML + state structure):

.. code-block:: bash

    salt '*' state.show_sls unbound

Apply the formula:

.. code-block:: bash

    salt '*' state.apply unbound

Dry-run mode:

.. code-block:: bash

    salt '*' state.apply unbound test=True