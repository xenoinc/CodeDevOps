# Oh-My-Posh Themes

## Install

Steps to install, [Oh My Posh](https://ohmyposh.dev/)

Be sure to uninstall, "Posh-GIT", `uninstall-module posh-git`

1. `winget search oh-my-posh`
2. `winget install JanDeDobbeleer.OhMyPosh`
3. `oh-my-posh font install`
4. Set it to, "M???"
5. `oh-my-posh get shell`
6. Get the PowerShell config path, `$profile`
7. Initialize and set the theme in the next step, "Set Our Theme"

## Set Our Theme

1. Run the following command (_changing the path_)

```powershell
oh-my-posh init pwsh --config "C:\PATH-TO\lib\omp-themes\xeno-clean.omp.json" | Invoke-Expression
```

## Commands

* Get list of themes, `Get-PoshThemes`
* Export current theme, `oh-my-posh config export --output ~\mytheme.omp.json`
* Change Theme for session, `oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\kali.omp.json" | Invoke-Expression`
* `Get-PSReadLineOption`

## Other themes

```powershell
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\kali.omp.json" | Invoke-Expression
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\hul10.omp.json" | Invoke-Expression
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\agnoster.minimal.omp.json" | Invoke-Expression
```
