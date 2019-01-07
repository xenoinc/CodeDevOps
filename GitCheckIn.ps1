<#
  Git Helpers for PowerShell
  Author: Damian Suess
  Revision: 2 - 2018-07-30 (2018-10-03)

  Resources:
  https://stackoverflow.com/questions/2157554/how-to-handle-command-line-arguments-in-powershell
#>

# Load cmdline args (MUST BE FIRST!)
param (
  [Parameter(Mandatory=$true)][string]$msg,
  [switch]$a = $false
);

# Include Files
. "GitTools.ps1";

Write-Host "Git Commiting and Pushing..." -ForegroundColor yellow;

$branch = GitCurrentBranch;
$branch = $branch.Trim();

if ($branch -eq "")
{
  Write-Host "No repository found in currect directory." -ForegroundColor red;
  exit;
}

Write-Output "Input message: '$msg' and add-all: '$a'";

GitCommit($msg, $a);
GitPush;

Write-Host "Done!";
