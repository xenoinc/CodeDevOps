<#
  Git Helpers for PowerShell
  Author: Damian Suess  - 2018-07-30
  Revision: 3 - 2019-01-16

  TODO:
    - GitCheckIn $message (check-in/push)
    - GitPush - Set branch tracking or no tracking

  Change Log:
  2019-01-16 - 0.3  - Added GitPull and cleaned up functions
  2019-01-02 - 0.2b - Added notes for GitPush without tracking branch
  2018-10-03 - 0.2  - Some enhancements
  2018-07-30 - 0.1  - Created
#>

# Clear out cache of previous PowerShell sessions
#Remove-Variable * -ErrorAction SilentlyContinue;
#Remove-Module *;
#$error.Clear();
# Clear-Host;

function GitCurrentBranch() {
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

function GitMerge([string]$branch)
{
  Invoke-Expression "git merge $branch";
}

function GitCommit([string]$message)
{
  # Example:
  #   GitCommit("My message goes here")($true);

  Invoke-Expression "git commit -m ""$message"" -a -v";
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
