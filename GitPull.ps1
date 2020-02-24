<#
  Git commandline helpers for PowerShell
  Author: Damian Suess
  Revision: 1 - 2019-01-16

  Usage:
    GitPull             ; Pulls current branch defaulting remote to "origin"
    GitPull "NotOrigin" ; Pulls current branch from specified remote
    GitPull -u          ; Pull merging unrelated histories

  TODO:
    - Pulls branch and sets tracking so you can simply execute, ``git push`` next time
      GitPull "NotOrigin" -track
    - After pulling check for "fatal: refusing to merge unrelated histories" and suggest '-u' switch.
  Change Log:
    2019-01-16  0.1 - Created
#>

# Commandline Params ---
param(
  [parameter(Mandatory=$false)][string] $remote = "origin",
  [parameter(Mandatory=$false)][switch] $u = $false,
  [Parameter(Mandatory=$false)][switch] $h = $false
  # ,[parameter(Mandatory=$false)][switch] $track = $false
);

# Include Files --------
. "$PSScriptRoot/lib/GitHelpers.ps1";

# Our code -------------
if ($h -eq $true)
{
  Write-Host "GitPull HELP";
  Write-Host "-------------";
  Write-Host "Pulls branch to remote repository" -ForegroundColor Yellow;
  Write-Host "  GitPull -remote <string>  ; Pulls from specified remote (default: origin)" -ForegroundColor Yellow;
  Write-Host "  GitPull -u                ; Pull merging unrelated histories" -ForegroundColor Yellow;
  Write-Host "  GitPull -h                ; This help text" -ForegroundColor Yellow;
  Write-Host "";
  exit;
}

[string] $branchName = GitCurrentBranch;
if ($branchName.Trim() -eq "")
{
  Write-Host "No repository found in currect directory." -ForegroundColor Red;
  exit;
}

[string] $msg = "";
if ($u -eq $true)
{
  $msg = " with unrelated history";
}

Write-Host "Pulling branch '${branchName}'${msg} from origin remote '${remote}'..." -ForegroundColor Green;
GitPull($remote)($branchName)($u);

# if ($track)
# {
#   Write-Host "Pulling branch '${branchName}' with tracking..." -ForegroundColor Green;
#   GitPull($remote)($branchName)($true)
# }
# else
# {
#   Write-Host "Pulling branch '${branchName}'..." -ForegroundColor Green;
#   GitPull($remote)($branchName)($false);
# }
