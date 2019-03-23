<#
  Git commandline helpers for PowerShell
  Author: Damian Suess
  Revision: 1 - 2019-01-16

  Usage:
    GitPull             ; Pulls current branch defaulting remote to "origin"
    GitPull "NotOrigin" ; Pulls current branch from specified remote

  TODO:
    - Pulls branch and sets tracking so you can simply execute, ``git push`` next time
      GitPull "NotOrigin" -track

  Change Log:
    2019-01-16  0.1 - Created
#>

# Commandline Params ---
param(
  [parameter(Mandatory=$false)][string] $remote = "origin"
  # ,[parameter(Mandatory=$false)][switch] $track = $false
);

# Include Files --------
. "GitHelpers.ps1";

# Our code -------------
[string] $branchName = GitCurrentBranch;
if ($branchName.Trim() -eq "")
{
  Write-Host "No repository found in currect directory." -ForegroundColor Red;
  exit;
}

Write-Host "Pulling branch '${branchName}' from origin remote '${remote}'..." -ForegroundColor Green;
GitPull($remote)($branchName);

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
