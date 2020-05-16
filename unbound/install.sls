# -*- coding: utf-8 -*-
# vim: ft=sls

{% from slspath+"/map.jinja" import unbound with context %}

unbound_package:
    pkg.installed:
        - name: {{unbound.package}}

unbound_download_cache:
  cmd.run:
    - name: "curl -o {{unbound.cache_file}} ftp://ftp.internic.net/domain/named.cache"
    - skip_verify: True
    - user: root
