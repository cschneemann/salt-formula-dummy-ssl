---
{% set certsdir = salt['pillar.get']('dummyssl.certsdir', "/srv/obs/certs") %}
{% set ssl_key = certsdir+salt['pillar.get']('dummyssl.key', "/server.key") %}
{% set ssl_csr = certsdir+salt['pillar.get']('dummyssl.csr', "/server.csr") %}
{% set ssl_crt = certsdir+salt['pillar.get']('dummyssl.crt', "/server.crt") %}
{% set ssl_keylength = salt['pillar.get']('dummyssl.keylength', 2048) %}
{% set ssl_subj = salt['pillar.get']('dummyssl.subj', '"/C=DE/ST=Bavaria/L=Munich/O=Penguin Dev/OU=Testing/CN=*"') %}

{{certsdir}}:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

ssl_key:
  cmd.run:
    - name: openssl genrsa -out {{ssl_key}} {{ssl_keylength}}
    - cwd: {{certsdir}}
    - creates: {{ssl_key}}

ssl_csr:
  cmd.run:
    - name: openssl req -new -key {{ssl_key}} -out {{ssl_csr}} -subj {{ssl_subj}} 
    - cwd: {{certsdir}}
    - creates: {{ssl_csr}}

ssl_crt:
  cmd.run:
    - name: openssl x509 -req -days 365 -signkey {{ssl_key}} -in {{ssl_csr}} -out {{ssl_crt}}
    - cwd: {{certsdir}}
    - creates: {{ssl_crt}}

