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
  [parameter(Mandatory=$false)][switch] $push = $false,
  [parameter(Mandatory=$false)][string] $syncBranch = "develop",
  [parameter(Mandatory=$false)][string] $remote = "origin",
  [parameter(Mandatory=$false)][bool] $useCheckout = $false
);

# Clear out cache of previous PowerShell sessions
#Remove-Variable * -ErrorAction SilentlyContinue;
#Remove-Module *;
#$error.Clear();
## Clear-Host;

# Include Files --------
. "$PSScriptRoot/lib/GitHelpers.ps1";

# Our code -------------
$branch = GitCurrentBranch;
$branch = $branch.Trim();

if ($branch -eq "")
{
  Write-Host "No repository found in currect directory." -ForegroundColor Red;
  exit;
}

$stopWatch = New-Object System.Diagnostics.Stopwatch
$stopWatch.Start()

Write-Host "------------------------------" -ForegroundColor Yellow;
Write-Host "Syncing '${branch}' with '${syncBranch}' branch..." -ForegroundColor Yellow;

if ($useCheckout -eq $false)
{
  Write-Host "Fetching latest..." -ForegroundColor Yellow;
  Invoke-Expression "git fetch";
  
  Write-Host "Fetching latest branch, '${syncBranch}'..." -ForegroundColor Yellow;
  Invoke-Expression "git fetch ${remote} ${syncBranch}:${syncBranch}";

  Write-Host "Merging '${syncBranch}' with '${branch}'..." -ForegroundColor Yellow;
  Invoke-Expression "git merge ${syncBranch}";
}
else
{
  Write-Host "Switching to ${syncBranch}..." -ForegroundColor Yellow;
  GitCheckout($syncBranch);

  Write-Host "Pulling latest..." -ForegroundColor Yellow;
  GitPull($remote)($syncBranch);

  Write-Host "Switching back to ${branch}..." -ForegroundColor Yellow;
  GitCheckout($branch);

  Write-Host "Merging branches..." -ForegroundColor Yellow;
  GitMerge($syncBranch);
}

# Automatically PUSH branch upstream via "-push" switch
if ($push)
{
  Write-Host "Pushing updated branch..." -ForegroundColor Green;
  GitPush($remote)($branch);
}

$stopWatch.Stop();
Write-Host "Sync with '${syncBranch}' complete!" -ForegroundColor Green;
Write-Host "Elapsed Time: " $stopWatch.Elapsed -ForegroundColor Green;
Write-Host "";
