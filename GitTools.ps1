<#
  Git Helpers for PowerShell
  Author: Damian Suess
  Revision: 2.b - 2018-07-30 (2018-10-03)

  TODO:
    - GitCheckIn $message (check-in/push)
    - GitPush - Set branch tracking or no tracking

  Change Log:
  2019-01-02  0.2b  - Added notes for GitPush without tracking branch
  2018-10-03  0.2   - Some enhancements
  2018-07-30  0.1   - Created
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

function GitPull()
{
  Invoke-Expression "git pull";
}

function GitMerge([string]$branch)
{
  Invoke-Expression "git merge $branch";
}

function GitCommit([string]$message, [bool]$autoStage)
{
  # Example:
  #   GitCommit("My message goes here")($true);

  $args = "";
  if ($autoStage) { $args = "-a"; }

  Invoke-Expression "git commit -m ""$message"" $args";
}

function GitPush([string] $remote, [string] $branch)
{
  # Example:
  #   GitPush("origin")("MyBranch");

  write-host "'$remote'";
  write-host "'$branch'";

  # Set Tracking: Invoke-Expression "git push -u --progress ""${remote}"" ""${branch}""";
  # No Tracking:  Invoke-Expression "git push --progress ""origin"" ""${branch}:${branch}""";
  
  if (($remote -ne "") -and ($branch -ne "")) {
    Invoke-Expression "git push -u --progress ""${remote}"" ""${branch}""";
  } else {
    Invoke-Expression "git push";
  }
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
