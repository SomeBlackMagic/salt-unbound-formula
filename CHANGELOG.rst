Changelog
=========

`1.0.0 <https://github.com/SomeBlackMagic/salt-unbound-formula/releases/tag/v1.0.0>`__ (2026-08-26)
-----------------------------------------------------------------------------------------------------

**Features**

- Multi-OS support: Debian, Ubuntu, RedHat, FreeBSD, Arch, Gentoo, OpenBSD, Suse
- Configurable server options, stub zones, forward zones via Pillar
- DNSSEC support via auto-trust-anchor
- Automatic DNS root hints download from internic.net
- Remote control section support

**Bug Fixes**

- Fix idempotency of root hints download (use ``file.managed`` instead of ``cmd.run``)
- Fix Ubuntu/Debian osmap deduplication (Ubuntu ``os_family`` is ``Debian`` in Salt)
- Fix Ubuntu defaults file path to come from map instead of inline grain check

**Improvements**

- Use modern ``service.running`` state syntax
- Use ``defaults_file`` from osmap for Debian/Ubuntu ``/etc/default/unbound``
- Switch from FTP to HTTPS for named.cache download
- Clean YAML-only ``pillar.example`` with comments