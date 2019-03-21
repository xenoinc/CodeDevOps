<#
  Git commandline helpers for PowerShell
  Author: Damian Suess
  Revision: 1 - 2019-01-16

  Usage:
    GitPrune        ; Regular fetch and prune (fetch -p)
    GitPrune -sync  ; Remote fetch & prune, plus sync with server

  TODO:
    [ ] Output which branches were removed by prune
        listing "Remote" and "Local" seperately

  Change Log:
    2019-0321 - 0.1 - Created
#>

# Commandline Params ---
param(
  [parameter(Mandatory=$false)][switch] $sync = $false
);

# Include Files --------
. "GitHelpers.ps1";

# Our code -------------
[string] $pruneType = "";
if ($sync -eq $true)
{
  $pruneType = "with remote sync ";
  GitPrune($true);
} else {
  GitPrune($false);
}

Write-Host "Git Prune ${pruneType}completed." -ForegroundColor Green;
