# Oh-My-Posh Themes

## Uninstall POSH-GIT

1. Open Terminal, `$PROFILE`
2. Remove line, `Import-Module posh-git`
3. Optional, uninstall the `posh-git` module, `uninstall-module posh-git`

## Install

Steps to install, [Oh My Posh](https://ohmyposh.dev/)

1. `winget search oh-my-posh`
2. `winget install JanDeDobbeleer.OhMyPosh`
3. Relaunch terminal window as Administrator
   1. `oh-my-posh font install`
   2. Select, "CascadiaMono" or "Meslo"
4. Validate shell, `oh-my-posh get shell`
   1. Should return, `pwsh`
5. Get the PowerShell config path, `$PROFILE`
6. Initialize and set the theme in the next step, "Set Our Theme"
7. Initialize OMP
   1. `code $PROFILE`  or  `notepad $PROFILE`
   2. Add line, `oh-my-posh init pwsh --config "C:\PATH-TO\lib\omp-themes\xeno-clean.omp.json" | Invoke-Expression`
   3. Reinitialize `. $PROFILE`

### Configure Font

Open Windows Terminal `settings.json` via, `Ctrl + Shift + ,`

More info found [here](https://ohmyposh.dev/docs/installation/fonts).

Recommended Fonts:

* [CaskaydiaMono Nerd Font Mon](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/CascadiaMono.zip)
* `MesloLGM Nerd Font`

```json
    "profiles":
    {
        "defaults":
        {
            "opacity": 86,
            "useAcrylic": true,
            "font":
            {
                "face": "CaskaydiaMono Nerd Font Mono"
            }
        },
```

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

### POSH-Git Symbols

```powershell
$BranchGoneStatusSymbol           = [PoshGitTextSpan]::new([char]0x00D7, [ConsoleColor]::DarkCyan) # × Multiplication sign
$BranchIdenticalStatusSymbol      = [PoshGitTextSpan]::new([char]0x2261, [ConsoleColor]::Cyan)     # ≡ Three horizontal lines
$BranchAheadStatusSymbol          = [PoshGitTextSpan]::new([char]0x2191, [ConsoleColor]::Green)    # ↑ Up arrow
$BranchBehindStatusSymbol         = [PoshGitTextSpan]::new([char]0x2193, [ConsoleColor]::Red)      # ↓ Down arrow
$BranchBehindAndAheadStatusSymbol = [PoshGitTextSpan]::new([char]0x2195, [ConsoleColor]::Yellow)   # ↕ Up & Down arrow
```
