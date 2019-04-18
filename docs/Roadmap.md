# DevOps Future
Consider moving all PowerShell script scripts under the ``Common`` subfolder and only keep ``DevOps.ps1`` in the root (_C:\BuildTools_).

Under the main root folder should just be DevOps or something else which will contain an ``-install`` parameter which will register CmdLets via ``Set-Alias``.

## Installation
We could use ``DevOps -install`` to register our CmdLets.

### Set session alias
```powershell
Set-Alias -Name GitPull -Value "C:\BuildTools\Common\Git\GitPull.ps1"
```

### Commands
* ``$profile``
* ``Get-Module -listavailable`` - List available PS commands
* ``Import-Module <MyFunction>`` - Use the module
* ``Get-Command -module <MyFunction>`` - Get list of functions in your module

ref: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_scopes?view=powershell-5.1

### See Also
By using Export-ModuleMember, we'll be able to install our git commands.

Consider the [Example using Export-ModuleMember](https://github.com/dahlbyk/posh-git/blob/master/src/posh-git.psm1)
from the Posh-Git project.

## Folder Structure
Below is the suggested folder structure for BuildTools so we don't just have a folder of cluttered shit.

| Structure | Desc |
|-----------|------|
| .\DevOps.ps1  | Main executable for running commands and installer of others |
| .\Common\     | Core files for Xeno-DevOps |
| .\Cache\      | Downloaded files stored here. i.e. Visual Studio project structure such as StyleCop rules |


## DevOps Commands

### -install
* Creates and registers folder (``C:\BuildTools\``)
* Download all script files from GitHub repo and place into ``Common`` folder
* Create empty folder, ``Cache`` used for downloads
* Install CmdLets

### Visual Studio Project (-vs)
For now, simply omit the ``-vs`` and use ``-create``, ``-update``, etc.

#### Create (-create)
Create standard project folder structure

* .gitignore
* readme.md
* license.md
* \docs\
* \src\...

#### Update (-update)
Update all Visual Studio project core files

You can only execute this in the root folder of a project. It will check for the following files to validate that you're in the root folder. If not, you will be prompted.

Validation files:
* ``.gitignore``
* ``readme.md``
* ``license.md``

| Command | Description |
|:--------|:------------|
| -update all | Update all VS project files |
| -update StyleCop | Updates only the StyleCop.Analyzers rules |
| -update CodeMaid | CodeMaid rules |
| -update EditorConfig | EditorConfig rules |
| -update LicenseHeader | .LicenseHeader template |

#### Update Dependencies (-ud)
Update project dependencies using project's MSBuild script


## Reference
* [PowerShell Set-Alias](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/set-alias?view=powershell-6)
* Install PS commands [Example](https://github.com/Unitrends/unitrends-pstoolkit)
    * Downloads, extracts, installs, validates, cleanup
