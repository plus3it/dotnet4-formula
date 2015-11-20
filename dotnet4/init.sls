{%- from "dotnet4/map.jinja" import dotnet4 with context %}

{%- set osrelease = salt['grains.get']('osrelease','') %}

{%- if salt['cmd.run'](
  cmd=dotnet4.hotfix_id + ' -in (get-wmiobject -class \
      win32_quickfixengineering).HotFixID',
  shell='powershell') == 'True'
%}
# Check whether the Hotfix corresponding to the .NET version is already 
# installed.
dotnet4:
  test.configurable_test_state:
    - name: '.NET {{ dotnet4.version }} already installed'
    - changes: False
    - result: True
    - comment: 'Version {{ dotnet4.version }} of package .NET is already installed.'

{%- elif osrelease in [ '8', '2012Server' ] %}
# For Windows 8, ws2012, or ws2012r2, use the pkg *module* to install .NET.
dotnet4:
  module.run:
    - name: pkg.install
    - pkgs:
      - 'dotnet'
    - version: {{ dotnet4.version }}

{%- else %}
# For every other Windows version, use the pkg state to install the specified 
# version of .NET.
dotnet4:
  pkg.installed:
    - name: 'dotnet'
    - version: {{ dotnet4.version }}
    - allow_updates: True

{%- endif %}
