
[string[]] $list = git branch -a
[string] $curBranch = "";
$locals = New-Object System.Collections.ArrayList;
$remotes = New-Object System.Collections.ArrayList;
# [string[]] $locals;  - SLOW! it creates a copy when adding
# [string[]] $remotes;
# [string] $remote = "origin";

Write-Host "Starting...";

$list.ForEach({
  $ndx = $_.Trim();
  # Write-Host $ndx;

  if ($ndx.SubString(0,1) -eq "*") {
    $curBranch = $ndx.SubString(2);
  }
  
  [string[]] $elements = $ndx.Split("/");
  if ($elements[0] -eq "remotes") {
    # Write-Host "IsRemote!";
    # Add $ndx to $remotes skipping the first two elements;
    # $remotes += $null, $null, $elements;
    #
    # $a = "1","2","3","4","5"
    # $null, $null, $a=$a;   # removes the first 2 items of $a
    # 
    $null, $null, $elements = $elements;

    # PROBLEM: This isn't creating a new array. it's mashing all branches into 1 string
    [string] $branch = $elements -Join "/";
    $remotes.Add($branch);
    # $remotes += $branch;   # Old way for [string[]] $remotes;  - It's broken
  }
  else 
  {
    if ($ndx.SubString(0, 1) -eq "*") {
      $ndx = $ndx.SubString(2);
    }
    # $locals += $ndx;
    $locals.Add($ndx);
  }
});

Write-Host "=======";
Write-Host "CURRENT: $curBranch";
Write-Host "REMOTES:";
$remotes.ForEach({ Write-Host ": $_"; });
# $remotes.Count;

Write-Host "-------";
Write-Host "LOCALS:";
$locals.ForEach({ Write-Host ": $_"; });

Write-Host "- - - -";

# Display what LOCALS don't exist in REMOTES
$locals.ForEach({

  # Pre-check
  if ($remotes.Contains($_) -eq $false -and $_ -eq $curBranch) {
    Write-Host "WARNING: Current branch doesn't exist on any remote!" -ForegroundColor Red;
  } elseif ($remotes.Contains($_) -eq $false -and $_ -ne $curBranch) {
    Write-Host "DELETE ME: '$_'" -ForegroundColor Yellow;
  }
});

<#
$list = git branch -a
$current = "";
foreach-object -inputobject $list {

  Write-Host $_.Trim();
  $ndx = $_.Trim();
  
  Write-Host "Sub: $ndx.SubString(0,1)";
  
  if ($ndx.SubString(0, 1) -eq "*") {
    $current = $ndx;
  }
}

Write-Host "Current: $current";
#>


<#
$list = git branch -a
$current = "";
foreach-object ($branch in $list)
{
  Write-Host $branch.Trim();
  $ndx = $_.Trim();
  
  Write-Host "Sub: $ndx.SubString(0,1)";
  
  if ($ndx.Substring(0, 1) -eq "*") {
    $current = $ndx;
  }
}

Write-Host "Current: $current";
#>
