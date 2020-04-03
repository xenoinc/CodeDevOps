<#
  Git commandline helpers for PowerShell
  Author: Damian Suess
  Revision: 1 - 2019-01-16

  Usage:
    GitStaus    - Returns the counts of each status type

  Change Log:
    2019-0321 - 0.1 - Created
#>

# Include Files --------
. "$PSScriptRoot/lib/GitHelpers.ps1";

# Our code -------------
GitStatus;

Write-Host "GitStatus completed." -ForegroundColor Green;
