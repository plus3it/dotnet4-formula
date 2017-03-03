[![license](https://img.shields.io/github/license/plus3it/dotnet4-formula.svg)](./LICENSE)
[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/plus3it/dotnet4-formula?branch=master&svg=true)](https://ci.appveyor.com/project/plus3it/dotnet4-formula)

# dotnet4

Microsoft .NET (dotnet) behaves as a package on some versions of the Microsoft
Operating System, and as an update/hotfix on other versions of the Microsoft OS.
The Salt package manager for Windows handles software packages just fine, but
currently does not understand Windows updates or hotfixes.

This salt formula incorporates logic to check whether the specified version of
.NET 4 has already been installed as a Windows hotfix. The mapping of .NET
version to a Hotfix ID is done via a lookup table in map.jinja. If the hotfix
is not present, and if the OS version treats .NET as an update, the formula
uses the module.run state to install the .NET package. If the OS version treats
.NET as a software package, the formula uses the pkg.install state to install
the .NET package.

**Versions of the Microsoft OS known to treat .NET 4 as a hotfix**:
- Microsoft Windows 8.1
- Microsoft Windows 10
- Microsoft Windows Server 2012 R2
- Microsoft Windows Server 2016

**Versions of the Microsoft OS known to treat .NET 4 as a software package**:
- Microsoft Windows 2008 R2

Other versions of the Microsoft OS have not been tested.

## Dependencies

- Properly configured salt winrepo package manager, in a master or masterless
configuration.
- Package definition for dotnet from salt-winrepo must be available in the
winrepo database.
    - https://github.com/saltstack/salt-winrepo/blob/master/dotnet.sls

## Available States

### dotnet4

Install .NET 4

## Configuration

This formula supports a configuration via pillar. There is a single pillar
variable, the version of .NET to install. Below is an example of a complete
pillar configuration:

    dotnet4:
      lookup:
        version: '4.5.51209'
