# -*- coding: utf-8 -*-
# vim: ft=sls

{% from slspath+"/map.jinja" import unbound with context %}

unbound_config:
  file.managed:
    - name: {{unbound.config_file}}
    - source: salt://{{slspath}}/files/unbound.conf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 0440
    - context:
        config: {{unbound | json }}

unbound_download_cache:
  file.managed:
    - name: {{unbound.cache_file}}
    - source: ftp://ftp.internic.net/domain/named.cache
    - user: root
    - group: root

