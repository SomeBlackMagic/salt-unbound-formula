# -*- coding: utf-8 -*-
# vim: ft=sls

{% from slspath+"/map.jinja" import unbound with context %}

unbound_service:
    service.running:
        - name: {{ unbound.service }}
        - enable: True

{% if unbound.get('defaults_file') -%}
unbound_defaults:
    file.managed:
        - name: {{ unbound.defaults_file }}
        - template: jinja
        - user: root
        - group: root
        - mode: '0644'
        - source: salt://{{ slspath }}/files/default.jinja
        - require_in:
            - service: unbound_service
{%- endif %}