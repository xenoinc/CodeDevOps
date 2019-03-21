<#
  Git Helpers for PowerShell
  Author: Damian Suess  - 2018-07-30
  Revision: 4 - 2019-03-21
  Description:
    Collection of Git helper functions in PowerShell

  Note:
    We do recommend installing 'posh-git' as it integrates seemlessly into your command line
    https://github.com/dahlbyk/posh-git

  TODO:
    [ ] GitCheckIn $message (check-in/push)
    [ ] GitPush - Set branch tracking or no tracking
    [ ] Integrate our GitHelpers into PowerShell commands via PowerShellGet\Install-Module Xeno-GitDevOps

  Change Log:
    2019-03-21 - 4  - Added GitPrune with sync, GitStatus, added notes
    2019-01-16 - 3  - Added GitPull and cleaned up functions
    2019-01-02 - 2b - Added notes for GitPush without tracking branch
    2018-10-03 - 2  - Some enhancements
    2018-07-30 - 1  - Created
#>

# Clear out cache of previous PowerShell sessions
#Remove-Variable * -ErrorAction SilentlyContinue;
#Remove-Module *;
#$error.Clear();
# Clear-Host;

function GitCurrentBranch()
{
  $cmd = Invoke-Expression "git rev-parse --abbrev-ref HEAD";
  # $cmd = git rev-parse --abbrev-ref HEAD | Out-String

  #if ($null -eq $cmd)
  if (IsNull($cmd))
  {
    $cmd = "";
  }

  return $cmd;
}

function GitCheckout([string]$branch)
{
  Invoke-Expression "git checkout $branch";
}

function GitCommit([string]$message)
{
  # Example:
  #   GitCommit("My message goes here")($true);

  Invoke-Expression "git commit -m ""$message"" -a -v";
}

function GitFetch([bool] $prune)
{
  [string] $p = "";
  if ($prune -eq $true) { $p = "-p"; }

  Invoke-Expression "git fetch -v ${p}";
}

function GitMerge([string]$branch)
{
  Invoke-Expression "git merge ""$branch""";
}

function GitPrune([bool] $syncPrune)
{
  GitFetch($true);

  if ($syncPrune -eq $true)
  {
    Write-Host "Syncing with server..." -ForegroundColor Blue;

    # %   - ForEach-Object
    # sls - Select-String
    git branch -vv | sls gone `
      |% { $_.ToString().Trim() -split '\s+' | Select-Object -first 1 } `
      |% { git branch -D $_ }
  }
}

function GitPull([string] $remote, [string] $branch)
{
  # Example:
  #   Pull and set tracking - GitPull("origin")("MyBranch")(true);
  #   Pull with no tracking - GitPull("origin")("MyBranch")(false);
  #
  # Consider adding, [bool] $withTracking=true
  # git branch --set-upstream-to=origin/<branch> feature-en-InsertCfg-ROI

  Invoke-Expression "git pull ""${remote}"" ""${branch}""";
}

function GitPush([string] $remote, [string] $branch, [bool] $withTracking)
{
  # Example:
  #   GitPush("origin")("MyBranch");          - Push without setting tracking
  #   GitPush("origin")("MyBranch")($true);   - Push with tracking

  # Set Tracking: Invoke-Expression "git push -u --progress ""${remote}"" ""${branch}""";
  # No Tracking:  Invoke-Expression "git push --progress ""origin"" ""${branch}:${branch}""";

  if ($withTracking -eq $true)
  {
    # With setting tracking. Required remote and branch name to be set
    if ($remote.Trim() -eq "") {
      Write-Host "ERROR[1]: Remote name was not provided. It is required for to set tracking." -ForegroundColor Red;
    } elseif ($branch.Trim() -eq "") {
      Write-Host "ERROR[2]: Branch name was not provided. It is required for to set tracking." -ForegroundColor Red;
    }
    else
    {
      Write-Host ">>[1] Pushing branch (${branch}) to remote (${remote}) with tracking..." -ForegroundColor Blue;
      Invoke-Expression "git push -u --progress ""${remote}"" ""${branch}""";
    }
  }
  else
  {
    # No tracking
    if (($remote.Trim() -ne "") -and ($branch.Trim() -ne ""))
    {
      Write-Host ">>[2] Pushing branch (${branch}) to remote (${remote}) without tracking" -ForegroundColor Blue;
      Invoke-Expression "git push --progress ""${remote}"" ""${branch}:${branch}""";
      # OLD: Invoke-Expression "git push -u --progress ""${remote}"" ""${branch}""";
    }
    else
    {
      Write-Host ">>[3] Pushing branch to default remote (origin) without tracking" -ForegroundColor Blue;
      Invoke-Expression "git push";
    }
  }

  # OLD
  # if (($remote.Trim() -ne "") -and ($branch.Trim() -ne "")) {
  #   Invoke-Expression "git push -u --progress ""${remote}"" ""${branch}""";
  # } else {
  #   Invoke-Expression "git push";
  # }
}

function GitStatus()
{
  [bool] $untracked = $false;
  [int] $added = 0;
  [int] $modified = 0;
  [int] $deleted = 0;
  [bool] $ahead = $false;
  [int] $aheadCount = 0;

  [string] $output = Invoke-Expression "git status";
  [string] $branch = GitCurrentBranch;
  # $branches = $output[0].Split(' ');
  # [string] $branch = $branches[$branches.Length -1];

  $output | ForEach-Object {
    if ($_ -match "^\#.*origin/.*' by (\d+) commit.*") {
      $aheadCount = $matches[1];
      $ahead = $true;
    } elseif ($_ -match "deleted:") {
      $deleted += 1;
    } elseif (($_ -match "modified:") -or ($_ -match "renamed:")) {
      $modified += 1
    } elseif ($_ -match "new file:") {
      $added += 1
    } elseif ($_ -match "Untracked files:") {
      $untracked = $true;
    }
  };

  return @{"Untracked:" = $untracked;
           "Added-Files:" = $added;
           "Modified-Files:" = $modified;
           "Deleted:" = $deleted;
           "Ahead:" = $ahead;
           "Ahead-Count:" = $aheadCount;
           "Branch-Name:" = $branch};
}

function GitRepoName()
{
  $cmd = (git remote get-url origin).Split("/");
  [string] $host = $cmd[-2];
  [string] $repo = $cmd[-1];

  return $host + "/" + $repo;
}

function IsNull($objectToCheck) {
  if ($null -eq $objectToCheck) {
    return $true;
  }

  if ($objectToCheck -is [String] -and $objectToCheck -eq [String]::Empty) {
    return $true;
  }

  if ($objectToCheck -is [DBNull] -or $objectToCheck -is [System.Management.Automation.Language.NullString]) {
    return $true;
  }

  return $false;
}
