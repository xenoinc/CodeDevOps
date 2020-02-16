<#
  Git commandline helpers for PowerShell
  Author: Damian Suess
  Revision: 2 - 2018-07-30 (2018-10-03)

  Usage:
    GitSync         ; Sync current branch with develop
    GitSync -push   ; Sync current branch with develop and push changes (syncing branch)

  TODO:
    - GitCheckIn $message (check-in/push)
    - Option "-track" to set tracking; don't track by default
    - Option "-u" "-uh" to merge unrelated histories

  Change Log:
  2018-10-03  0.2 - Some enhancements
  2018-07-30  0.1 - Created
#>

# Commandline Params ---
param(
  [parameter(Mandatory=$false)][switch] $push = $false
);

# Clear out cache of previous PowerShell sessions
#Remove-Variable * -ErrorAction SilentlyContinue;
#Remove-Module *;
#$error.Clear();
## Clear-Host;

# Include Files --------
. "GitHelpers.ps1";

# Our code -------------
Write-Host "------------------------------" -ForegroundColor Yellow;
Write-Host "Syncing with develop branch..." -ForegroundColor Yellow;

$branch = GitCurrentBranch;
$branch = $branch.Trim();

if ($branch -eq "")
{
  Write-Host "No repository found in currect directory." -ForegroundColor Red;
  exit;
}

GitCheckout("develop");
GitPull;
GitCheckout($branch);
GitMerge("develop");
Write-Host "Sync complete!" -ForegroundColor Green;

# Automatically PUSH branch upstream via "-push" switch
if ($push)
{
  Write-Host "Pushing updated branch..." -ForegroundColor Green;
  GitPush("origin")($branch);
}

Write-Host "Current Branch: $branch" -ForegroundColor Yellow;
Write-Host "";
