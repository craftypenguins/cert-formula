# This is the main state file for deploying certificates

{% from "cert/map.jinja" import cert with context %}

include:
  - {{slspath}}.packages

# Create a CA certificate at target and register with Mine

/etc/pki:
  file.directory: []

/etc/pki/issued_certs:
  file.directory: []

cert_ca_key:
  x509.private_key_managed:
    - name: /etc/pki/ca.key
    - bits: 4096
    - backup: True

cert_ca_certificate:
  x509.certificate_managed:
    - name: /etc/pki/ca.crt
    - signing_private_key: /etc/pki/ca.key
    - CN: {{ cert.ca.cn }}
    - C: {{ cert.ca.country }}
    - ST: {{ cert.ca.state }}
    - L: {{ cert.ca.locality }}
    - basicConstraints: "{{ cert.ca.constraints }}"
    - keyUsage: "{{ cert.ca.key_usage }}" 
    - subjectKeyIdentifier: hash
    - authorityKeyIdentifier: keyid,issuer:always
    - days_valid: {{ cert.ca.days_valid }}
    - days_remaining: {{ cert.ca.days_remaining }} 
    - backup: True
    - require:
      - file: /etc/pki
      - pkg: cert_packages
      - x509: /etc/pki/ca.key

mine.send:
  module.run:
    - func: x509.get_pem_entries
    - kwargs:
        glob_path: /etc/pki/ca.crt
    - onchanges:
      - x509: /etc/pki/ca.crt

