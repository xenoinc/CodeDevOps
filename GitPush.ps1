<#
  Git commandline helpers for PowerShell
  Author: Damian Suess
  Revision: 1 - 2019-01-02

  Usage:
    GitPush           ; Pushes current branch without tracking
    GitPush -track    ; Pushes branch and sets tracking so you can simply execute, ``git push`` next time

  TODO:
  - Get branch
  - Exec command: ``git.exe push --progress "origin" feature/PomodoroInit:feature/PomodoroInit``

  Change Log:
    2019-01-02  0.1 - Created
#>

# Commandline Params ---
param(
  [Parameter(Mandatory=$false)][string] $remote = "origin",
  [Parameter(Mandatory=$false)][switch] $track = $false,
  [Parameter(Mandatory=$false)][switch] $h = $false
);

# Include Files --------
. "$PSScriptRoot/lib/GitHelpers.ps1";

# Our code -------------
if ($h -eq $true)
{
  Write-Host "GitPush HELP";
  Write-Host "-------------";
  Write-Host "Pushes branch to remote device" -ForegroundColor Yellow;
  Write-Host "  GitPush -t              Push current branch to ORIGIN and set branch tracking" -ForegroundColor Yellow;
  Write-Host "  GitPush -r <REMOTE>     Push current branch to specified remote" -ForegroundColor Yellow;
  Write-Host "  GitPush -r <REMOTE> -t  Push current branch to specified remote and set tracking" -ForegroundColor Yellow;
  Write-Host "  GitPush -h              This help text" -ForegroundColor Yellow;
  Write-Host "";
  Write-Host "  NOTE:" -ForegroundColor Yellow;
  Write-Host "  By setting TRACKING you can simply type, 'git push' without having to use this auto-detection for your specified branch." -ForegroundColor Yellow;
  exit;
}

$branch = GitCurrentBranch;
if ($branch.Trim() -eq "")
{
  Write-Host "No repository found in currect directory." -ForegroundColor Red;
  exit;
}

Write-Host "Pushing branch with tracking='${track}'..." -ForegroundColor Green;
GitPush($remote)($branch)($track);

# if ($track)
# {
#   Write-Host "Pushing branch with tracking..." -ForegroundColor Green;
#   Invoke-Expression "git push -u --progress ""origin"" ""${branch}""";
# }
# else
# {
#   Write-Host "Pushing branch..." -ForegroundColor Green;
#   Invoke-Expression "git push --progress ""origin"" ""${branch}:${branch}""";
# }
