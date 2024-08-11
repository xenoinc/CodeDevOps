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
    [ ] GitMerge opt to merge unrelated histories
        - git.exe merge --allow-unrelated-histories develop

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
  # "git branch --show-current"
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

function GitMergeUnrelated([string]$branch)
{
  Invoke-Expression "git merge --allow-unrelated-histories ""$branch""";
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

    ################
    # Alt Solutions:
    # 1. Use ``$list = git branch -a`` after a fetch with prune, and compare
    #    anything starting with "remotes/origin/" against those not starting
    #    and delete what's missing. To show item, use ``$list[2]`` to show 3rd item.
    #    NOTE:
    #     You must remove the 1st 2 characters and can't delete the one starting with "*".
    #     "*" is your current branch.
    #
    #    Note2:
    #     List each item. $_ contains the current item in $list
    #      ``foreach-object -inputobject $list {$_}``
    #
    # 2. ``git branch -vv`` This requires
    #   git checkout master; git remote update origin --prune; git branch -vv | Select-String -Pattern ": gone]" | % { $_.toString().Trim().Split(" ")[0]} | % {git branch -d $_}
    #
    ##    ``git checkout master``               Switches to the master branch
    ##    ``git remote update origin --prune``  Prunes remote branches
    ##    ``git branch -vv``                    Gets a verbose output of all branches (git reference)
    ##    ``Select-String -Pattern ": gone]"``  Gets only the records where they have been removed from remote.
    ##    ``% { $_.toString().Split(" ")[0]}``  Get the branch name
    ##    ``% {git branch -d $_}``              Deletes the branch
    #
  }
}

function GitPrune_Prototype([bool] $syncPrune)
{
  GitFetch($true);

  if ($syncPrune -eq $true)
  {
    Write-Host "Syncing with server..." -ForegroundColor Blue;

    [string[]] $list = git branch -a;

    #$list2 = git branch -a
    #Write-Prompt $list2.GetType().FullName;

    [string] $curBranch = [String]::Empty;
    [string] $branch = [String]::Empty;
    $locals = New-Object System.Collections.ArrayList;
    $remotes = New-Object System.Collections.ArrayList;
    $whiteList = New-Object System.Collections.ArrayList;

    [void]$whiteList.Add("master");
    [void]$whiteList.Add("develop");

    Write-Host "Starting...";

    $list.ForEach({
      $ndx = $_.Trim();

      if ($ndx.SubString(0,1) -eq "*") {
        $curBranch = $ndx.SubString(2);
      }

      [string[]] $elements = $ndx.Split("/");
      if ($elements[0] -eq "remotes") {
        $null, $null, $elements = $elements;
        $branch = $elements -Join "/";
        [void]$remotes.Add($branch);
      }
      else
      {
        if ($ndx.SubString(0, 1) -eq "*") {
          $ndx = $ndx.SubString(2);
        }
        [void]$locals.Add($ndx);
      }
    });

    Write-Host "Current branch: ${curBranch}";

    $locals.ForEach({
      #
      # TODO: Add whitelist - i.e. master, develop
      #
      # Pre-check
      if ($remotes.Contains($_) -eq $false -and $_ -eq $curBranch) {
        Write-Host "WARNING: Current branch doesn't exist on remote anymore!" -ForegroundColor Red;
      } elseif ($remotes.Contains($_) -eq $false -and $_ -ne $curBranch) {
        Write-Host "DELETE ME: '$_'" -ForegroundColor Yellow;
      }
    });
  }
}

function GitPull([string] $remote, [string] $branch, [bool] $unrelatedHistories = $false)
{
  # Example:
  #   Pull unrelated history - GitPull("origin")("MyBranch")($true);
  #
  # Consider adding, Pull and set tracking
  #   PARAM:  [bool] $withTracking=true
  #   CMD:    git branch --set-upstream-to=origin/<branch> feature-en-InsertCfg-ROI
  #   Usage:  GitPull("origin")("MyBranch")($false)($true);

  [string] $cmdEx = "-v ";
  if ($unrelatedHistories -eq $true)
  {
    # "git.exe pull --progress -v --no-rebase --allow-unrelated-histories "origin" master"
    $cmdEx = "--allow-unrelated-histories ";
  }

  Invoke-Expression "git pull ${cmdEx}""${remote}"" ""${branch}""";
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
  [string] $host = $cmd[-2];  # 2nd to last element in array
  [string] $repo = $cmd[-1];  # last element in array

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
