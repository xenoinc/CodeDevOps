<#
  Copyright 2019 Xeno Innovations, Inc.
  xProject DevOps dependency sync system
  Date: 2019-02-27
  Version: 0.1

  TODO:
    [ ] Place all framework templates in their own folders vs flat
    [/] Make it work

  Sample:
  DevOps -GetFramework    - Refresh all project rules (same as, get all)
  DevOps -get all         - Refresh all items
  DevOps -get stylecop    - Only refresh stylecop files
  DevOps -get editorcfg
  DevOps -get git         - GitIgnore
  DevOps -get MSBuild     - MSBuild proj files
#>

param(
  [parameter(Mandatory=$false)][string] $get = ""
#  , [parameter(Mandatory=$false)][bool] $GetFramework
#  # ,[parameter(Mandatory=$false)][switch] $track = $false
);

# Base folder paths
[string]$Global:_baseStyleCop = "https://raw.githubusercontent.com/xenoinc/XenoDevOps/master/stylecop/";

#region Methods

function DownloadFile([string] $url, [string] $output)
{
  $startTime = Get-Date;
  (New-Object System.Net.WebClient).DownloadFileAsync($url, $output);
  Write-Output "Time taken: $((Get-Date).Subtract($startTime).Seconds) second(s)";
}

function DownloadTest()
{
  <#
  $urlTest = "https://raw.githubusercontent.com/xenoinc/XenoDevOps/master/stylecop/stylecop.ruleset";
  $output = "$PSScriptRoot\test.xml";
  $startTime = Get-Date;

  #$wc = New-Object System.Net.WebClient;
  #$wc.DownloadFile($urlTest, $output);
  # (New-Object System.Net.WebClient).DownloadFile($urlTest, $output);
  (New-Object System.Net.WebClient).DownloadFileAsync($urlTest, $output);

  Write-Output "Time taken: $((Get-Date).Subtract($startTime).Seconds) second(s)";
  #>
  Write-Output "Code removed for testing only";
}

function CachePath($file)
{
  # DevOps cached folder ("C:\BuildTools\tmp\" + file)
  return "$PSScriptRoot/tmp/${file}";
}

function GetStyleCop()
{
  $file = "stylecop.ruleset";
  $output = Join-Path -Path "$pwd" -ChildPath $file;
  DownloadFile($Global:_baseStyleCop + $file)($output);


  $file = "stylecop.json";
  $output = Join-Path -Path "$pwd" -ChildPath $file;
  DownloadFile($Global:_baseStyleCop + $file)($output);
}

# Returns path to 'source' or 'src' folder
# If it doesn't exist, it will return string.empty
function GetSourceFolder()
{
  Write-Output "Entering GetSourceFolder()...";

  [string]$path;
  $path = Join-Path -Path "$pwd" -ChildPath "source";
  Write-Output "Testing '${path}'";
  if ([System.IO.Directory]::Exists($path))
  {
    return $path;
  }

  $path = Join-Path -Path "$pwd" -ChildPath "src";
  Write-Output "Testing '${path}'";
  if ([System.IO.Directory]::Exists($path))
  {
    return $path;
  }

  Write-Output "Exiting GetSourceFolder()...";
  return [String]::Empty;
}

#endregion Methods

# Write-Output $("path " + GetSourceFolder);
$srcFolder = GetSourceFolder;
if ($srcFolder -eq [String]::Empty)
{
  Write-Output "Missing 'source' or 'src' folder. Make sure you're in project root.";
  exit;
}

# Make sure we got a command
if ($get.Trim() -eq [String]::Empty)
{
  Write-Output "Nothing to do. Try typing, 'DevOps -get StyleCop' from project root folder";
  exit;
}

# Parse commands
$get = $get.Trim();
if ($get.ToLower() -eq "StyleCop".ToLower())
{
  GetStyleCop;
}
else
{
  Write-Output "Unknown GET command; exiting";
}
