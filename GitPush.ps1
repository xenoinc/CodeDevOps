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

param(
  [parameter(Mandatory=$false)][switch] $track = $false
);

. "GitTools.ps1";

$branch = GitCurrentBranch;
$branch = $branch.Trim();
if ($branch -eq "")
{
  Write-Host "No repository found in currect directory." -ForegroundColor Red;
  exit;
}

if ($track)
{
  Write-Host "Pushing branch with tracking..." -ForegroundColor Green;
  Invoke-Expression "git push -u --progress ""origin"" ""${branch}""";
}
else
{
  Write-Host "Pushing branch..." -ForegroundColor Green;
  Invoke-Expression "git push --progress ""origin"" ""${branch}:${branch}""";
}
