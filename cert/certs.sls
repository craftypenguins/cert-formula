# This is the main state file for deploying certificates

{% from "cert/map.jinja" import cert with context %}

include:
  - {{slspath}}.packages

/usr/local/share/ca-certificates:
  file.directory: []

/usr/local/share/ca-certificates/{{cert.lookup.internal_cert_filename}}:
  x509.pem_managed:
    - text: {{ salt['mine.get'](cert.lookup.ca_host, 'x509.get_pem_entries')[cert.lookup.ca_host][cert.lookup.ca_crt_file]|replace('\n', '') }}
