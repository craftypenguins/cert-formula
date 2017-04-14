# This is the main state file for deploying certificates

{% from "cert/map.jinja" import cert with context %}

# Install required packages
cert_packages:
  pkg.installed:
    - pkgs:
{% for pkg in cert.lookup.pkgs %}
      - {{ pkg }}
{% endfor %}

