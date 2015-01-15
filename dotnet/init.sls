{% from "dotnet/map.jinja" import dotnet with context %}

{% set osrelease = salt['grains.get']('osrelease','') %}

{% if salt['cmd.run'](
  cmd=dotnet.hotfix_id + ' -in (get-wmiobject -class \
      win32_quickfixengineering).HotFixID',
  shell='powershell') == 'True'
%}
# Check whether the Hotfix corresponding to the .NET version is already 
# installed.
dotnet:
  test.configurable_test_state:
    - name: '.NET {{ dotnet.version }} already installed'
    - changes: False
    - result: True
    - comment: 'Version {{ dotnet.version }} of package .NET is already installed.'

{% elif osrelease in [ '8', 'Server2012' ] %}
# For Windows 8, ws2012, or ws2012r2, use the pkg *module* to install .NET.
dotnet:
  module.run:
    - name: pkg.install
    - pkgs:
      - '.NET'
    - version: {{ dotnet.version }}

{% else %}
# For every other Windows version, use the pkg state to install the specified 
# version of .NET.
dotnet:
  pkg.installed:
    - name: '.NET'
    - version: {{ dotnet.version }}

{% endif %}
