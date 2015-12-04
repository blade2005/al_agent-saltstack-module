{% from "al_agents/defaults.sls" import syslog_ng_source with context %}

include:
  - al_agents

/etc/syslog-ng/syslog-ng.conf:
  file.append:
    - text:
      - "include '/etc/syslog-ng/conf.d/alertlogic.conf';"
    - onlyif:
      - ls /etc/init.d/syslog-ng
    - unless:
      - grep /etc/syslog-ng/conf.d/alertlogic.conf /etc/syslog-ng/syslog-ng.conf

/etc/syslog-ng/conf.d/alertlogic.conf:
  file.managed:
    - source: salt://al_agents/files/syslog-ng/alertlogic.conf
    - template: jinja
    - defaults:
       syslog_ng_source: {{ syslog_ng_source }}

    - onlyif:
      - ls /etc/init.d/syslog-ng

syslog-ng:
  service.running:
    - enable: True
    - reload: True
    - watch:
      - file: /etc/syslog-ng/conf.d/alertlogic.conf
      - file: /etc/syslog-ng/syslog-ng.conf
