<#
  Git commandline helpers for PowerShell
  Author: Damian Suess
  Revision: 1 - 2020-01-08

  Checkout (switch-to) branch.
  If it doesn't exist locally, check "remotes/origin/" by default. You can optionally
  specify a different remote other than the default.

  Usage:
    GitCheckout "BranchName"          ; Checkout branch, origin as default
    GitCheckout "BranchName" "origin" ; Pulls current branch from specified remote

  TODO:
    - Do the work
    - Fetch if it doesn't find branch on first try
    - Check alternative remote

  Change Log:
    2020-01-08  0.1 - Created
    2020-05-05  0.2 - Updated error messages
#>
# git checkout -b feature-MyBranch remotes/origin/feature-MyBranch --


# Commandline Params ---
param(
  [parameter(Mandatory=$true)][string] $branch = ""
  # , [parameter(Mandatory=$false)][string] $remote = "origin"
);

# Include Files --------
. "$PSScriptRoot/lib/GitHelpers.ps1";

$remote = "origin";

# Our code -------------
[string] $branchName = GitCurrentBranch;
if ($branchName.Trim() -eq $branch.Trim())
{
  Write-Host "DevOps: Already on that branch." -ForegroundColor Yellow;
  exit;
}

# Attempt to get it locally
GitCheckout($branch);

$branchName = GitCurrentBranch;
if ($branchName.Trim() -eq $branch.Trim())
{
  Write-Host "DevOps: Switched to $branch locally." -ForegroundColor Green;
  exit;
}

# TODO - If optional remote provided, use it first
# .. here ..

## TODO:
##  1. Check if branch exists remotely first
##  2. If does not exist, fetch
##  3. If does not exist, create a new one

# Attempt to get it from remote repository
Write-Host "DevOps: Branch does not exist locally." -ForegroundColor Yellow;
Write-Host "DevOps: Checking for branch on remote, ""$remote""..." -ForegroundColor Yellow;

# -b or not to -b ??
Invoke-Expression "git checkout ""$branch"" ""remotes/$remote/$branch""";
$branchName = GitCurrentBranch;

if ($branchName.Trim() -eq $branch.Trim())
{
  Write-Host "DevOps: Switched to '$branch' from remote." -ForegroundColor Green;
  exit;
}

# Fetch and try again from remote repository
Write-Host "DevOps: Branch not found on remote." -ForegroundColor Yellow;
Write-Host "DevOps: Fetching latest..." -ForegroundColor Yellow;
GitFetch;

Invoke-Expression "git checkout -b ""$branch"" ""remotes/$remote/$branch""";
$branchName = GitCurrentBranch;

if ($branchName.Trim() -eq $branch.Trim())
{
  Write-Host "DevOps: Switched to '$branch' from remote after 'fetch'." -ForegroundColor Green;
}
else
{
  Write-Host "DevOps: The branch, ""$branch"" could not be found on ""$remote""." -ForegroundColor Red;
  Write-Host "DevOps: Check that the spelling and remote are correct, or create a new branch." -ForegroundColor Yellow; 
}
