<#
  Git Helpers for PowerShell
  Author: Damian Suess  -  2018-07-30
  Revision: 3 - 2019-01-16

  Resources:
  https://stackoverflow.com/questions/2157554/how-to-handle-command-line-arguments-in-powershell

  Change Log:
  2019-01-16 - 0.3  - Cleaned up functionality and added help
#>

# Commandline Params ---
param (
  [Parameter(Mandatory=$true)][string]$msg,
  [Parameter(Mandatory=$false)][switch]$noPush = $false,
  [Parameter(Mandatory=$false)][switch]$help = $false
);

# Include Files---------
. "GitHelpers.ps1";

# Our code -------------
if ($h -eq $true)
{
  Write-Host "Git Check-in HELP";
  Write-Host "-----------------";
  Write-Host "Pushes branch to remote device" -ForegroundColor Yellow;
  Write-Host "  GitCheckin ""<MESSAGE>""          Check-in code with message and auto-PUSH" -ForegroundColor Yellow;
  Write-Host "  GitCheckin ""<MESSAGE>"" -noPush  Check-in but DO NOT push changes" -ForegroundColor Yellow;
  Write-Host "  GitCheckin -h                     This help text" -ForegroundColor Yellow;
  Write-Host "";
  exit;
}

[string]$branch = GitCurrentBranch;
if ($branch.Trim() -eq "")
{
  Write-Host "No repository found in currect directory." -ForegroundColor red;
  exit;
}

Write-Host "Git Commiting..." -ForegroundColor yellow;
GitCommit($msg)($a);

if ($noPush -eq $false)
{
  Write-Host "Git Commiting..." -ForegroundColor yellow;
  GitPush("origin")($branch);
}

Write-Host "Done!" -ForegroundColor Green;
