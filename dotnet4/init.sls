{%- from "dotnet4/map.jinja" import dotnet4 with context %}

{%- if dotnet4.hotfix_os %}
{#- For win8 or later, or ws2012 or later, use the pkg *module* to install .NET. #}
dotnet4:
  module.run:
    - name: pkg.install
    - m_name: dotnet
    - kwargs:
        version: {{ dotnet4.version }}
    - onlyif: 'powershell.exe -noprofile -command
        "if (@({{ dotnet4.hotfix_ids | map('tojson') | join(',') | replace('"','\\"') }}) |? { @((get-wmiobject -class win32_quickfixengineering).HotFixID) -contains $_ }) {
            echo \".NET {{ dotnet4.version }} or greater already installed\"; exit 1
        }"
    '
{%- else %}
{#- For every other Windows version, use the pkg state to install the specified
    version of .NET. #}
dotnet4:
  pkg.installed:
    - name: 'dotnet'
    - version: {{ dotnet4.version }}
    - allow_updates: True

{%- endif %}
