# -*- coding: utf-8 -*-
# vim: ft=sls

{% from salt.file.dirname(slspath)+"/map.jinja" import unbound with context %}

unbound_service:
    service:
        - running
        - name: {{unbound.service}}

{% if salt['grains'].get('os') == 'Ubuntu' -%}
unbound_defaults:
    file.managed:
        - name: /etc/default/unbound
        - template: jinja
        - user: root
        - group: root
        - mode: 644
        - source: salt://{{salt.file.dirname(slspath)}}/files/default.jinja
        - require_in:
            - service: unbound_service
{%- endif -%}
