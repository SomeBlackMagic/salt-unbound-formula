# -*- coding: utf-8 -*-
# vim: ft=sls

{% from slspath+"/map.jinja" import unbound with context %}

unbound_package:
    pkg.installed:
        - name: {{ unbound.package }}

unbound_download_cache:
  file.managed:
    - name: {{ unbound.cache_file }}
    - source: https://www.internic.net/domain/named.cache
    - skip_verify: True
    - user: root
    - group: root
    - mode: '0644'
    - require:
        - pkg: unbound_package
