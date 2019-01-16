<#
  Git Helpers for PowerShell
  Author: Damian Suess
  Revision: 2 - 2018-07-30 (2018-10-03)

  Resources:
  https://stackoverflow.com/questions/2157554/how-to-handle-command-line-arguments-in-powershell
#>

# Commandline Params ---
param (
  [Parameter(Mandatory=$true)][string]$msg,
  [Parameter(Mandatory=$false)][switch]$a = $false,
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
  Write-Host "  GitCheckin ""<MESSAGE>""      Check-in code with message" -ForegroundColor Yellow;
  Write-Host "  GitCheckin ""<MESSAGE>"" -a   Check-in including all untracked files" -ForegroundColor Yellow;
  Write-Host "  GitCheckin -h                 This help text" -ForegroundColor Yellow;
  Write-Host "";
  exit;
}

Write-Host "Git Commiting and Pushing..." -ForegroundColor yellow;

$branch = GitCurrentBranch;
if ($branch.Trim() -eq "")
{
  Write-Host "No repository found in currect directory." -ForegroundColor red;
  exit;
}

# Write-Output "Input message: '$msg' and add-all: '$a'";

GitCommit($msg)($a);
GitPush("origin")($branch);
# GitPush;

Write-Host "Done!";
