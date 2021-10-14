<#
  Git commandline helpers for PowerShell
  Author: Damian Suess
  Revision: 3 - 2021-10-11

  Usage:
    GitSync         ; Sync current branch with develop
    GitSync -push   ; Sync current branch with develop and push changes (syncing branch)

  TODO:
    - GitCheckIn $message (check-in/push)
    - Option "-force" to merge unrelated histories
    - Option "-track" to set tracking; don't track by default

  Change Log:
  2021-10-11  r3 - Merge unrelated histories
  2018-10-03  r2 - Some enhancements
  2018-07-30  r1 - Created
#>

# Commandline Params ---
param(
  [parameter(Mandatory=$false)][string] $syncBranch = "develop",
  [parameter(Mandatory=$false)][string] $remote = "origin",
  [parameter(Mandatory=$false)][switch] $push = $false,
  [parameter(Mandatory=$false)][switch] $force = $false,
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
$current = GitCurrentBranch;
$current = $current.Trim();

if ($current -eq "")
{
  Write-Host "No repository found in currect directory." -ForegroundColor Red;
  exit;
}

$stopWatch = New-Object System.Diagnostics.Stopwatch
$stopWatch.Start()

Write-Host "------------------------------" -ForegroundColor Yellow;
Write-Host "Syncing '${current}' with '${syncBranch}' branch..." -ForegroundColor Yellow;

if ($useCheckout -eq $false)
{
  Write-Host "Fetching latest..." -ForegroundColor Yellow;
  Invoke-Expression "git fetch";
  
  Write-Host "Fetching latest branch, '${syncBranch}'..." -ForegroundColor Yellow;
  Invoke-Expression "git fetch ${remote} ${syncBranch}:${syncBranch}";

  Write-Host "Merging '${syncBranch}' with '${current}'..." -ForegroundColor Yellow;
  GitMerge($syncBranch);
}
else
{
  Write-Host "Switching to ${syncBranch}..." -ForegroundColor Yellow;
  GitCheckout($syncBranch);

  Write-Host "Pulling latest..." -ForegroundColor Yellow;
  GitPull($remote)($syncBranch);

  Write-Host "Switching back to ${current}..." -ForegroundColor Yellow;
  GitCheckout($current);

  Write-Host "Merging branches..." -ForegroundColor Yellow;
  GitMerge($syncBranch);
}

# Automatically PUSH branch upstream via "-push" switch
if ($push)
{
  Write-Host "Pushing updated branch..." -ForegroundColor Green;
  GitPush($remote)($current);
}

$stopWatch.Stop();
Write-Host "Sync with '${syncBranch}' complete!" -ForegroundColor Green;
Write-Host "Elapsed Time: " $stopWatch.Elapsed -ForegroundColor Green;
Write-Host "";
