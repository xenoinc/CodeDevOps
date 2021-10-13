<#
  Git commandline helpers for PowerShell
  Author: Damian Suess
  Revision: 1 - 2021-10-11

  Usage:
    GitMerge <BranchName>         ;  branch with develop
    GitMerge <BranchName> -push   ; Sync current branch with develop and push changes (syncing branch)

  Change Log:
  2021-10-11  r1 - Created
#>

# Commandline Params ---
param(
  [parameter(Mandatory=$false)][string] $branch = "develop",
  [parameter(Mandatory=$false)][switch] $force = $false,
  [parameter(Mandatory=$false)][switch] $push = $false,
  [parameter(Mandatory=$false)][string] $remote = "origin"
);

# Include Files --------
. "$PSScriptRoot/lib/GitHelpers.ps1";

# Our code -------------
$current = GitCurrentBranch;
$current = $current.Trim();

if ($current -eq "")
{
  Write-Host "No repository found in currect directory." -ForegroundColor Red;
  exit;
}

if ($force)
{
  GitMergeUnrelated($branch);
}
else
{
  GitMerge($branch);
}

# Automatically PUSH branch upstream via "-push" switch
if ($push)
{
  Write-Host "Pushing updated branch..." -ForegroundColor Green;
  GitPush($remote)($current);
}
