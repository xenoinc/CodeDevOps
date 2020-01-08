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
#>

# git checkout -b feature-MyBranch remotes/origin/feature-MyBranch --

# Commandline Params ---
param(
  [parameter(Mandatory=$true)][string] $branch = ""
  # , [parameter(Mandatory=$false)][string] $remote = "origin"
);

# Include Files --------
. "GitHelpers.ps1";

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
  Write-Host "DevOps: Switched to $branch." -ForegroundColor Green;
  exit;
}

# TODO - If optional remote provided, use it first
# .. here ..

# Attempt to get it from origin
Invoke-Expression "git checkout -b $branch remotes/origin/$branch";
$branchName = GitCurrentBranch;

if ($branchName.Trim() -eq $branch.Trim())
{
  Write-Host "DevOps: Switched to $branch from remote." -ForegroundColor Green;
  exit;
}

# Fetch and try again from origin
GitFetch;

Invoke-Expression "git checkout -b $branch remotes/origin/$branch";
$branchName = GitCurrentBranch;

if ($branchName.Trim() -eq $branch.Trim())
{
  Write-Host "DevOps: Switched to $branch from remote after 'fetch'." -ForegroundColor Green;
  exit;
}
