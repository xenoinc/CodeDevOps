<#
  DevOps commandline helpers for PowerShell
  Author: Damian Suess
  Revision: 1 - 2021-01-17

  Change Log:
    2021-01-17  r1 - Created
#>


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

function CachePath([string] $file)
{
  # DevOps cached folder ("C:\BuildTools\tmp\" + file)
  return "$PSScriptRoot/../tmp/${file}";
}

<#
.SYNOPSIS
Copy file from local 'templates' folder to specified path

.PARAMETER srcFile
Source template file or folder

.PARAMETER dest
Destination folder
#>
function CopyTemplate([string] $srcFile, [string] $dest)
{
  $from = "$PSScriptRoot/../templates/${srcFile}";

  if ([System.IO.File]::Exists($from)) {
    Copy-Item $from -Destination $dest
    Write-Output "Copied '${from}' -> '${dest}'";
  } else {
    Write-Output "Missing DevOps template file. DevOps 'templates' folder may be missing or corrupt";
    Write-Output "- FROM: '${from}'";
    Write-Output "- TO:   '${dest}'";
  }
}

<#
.SYNOPSIS
Copy StyleCope files from server into working directory

.NOTES
Currently not stable, do not use this function yet.
#>
function GetStyleCop()
{
  $file = "StyleCop.Analyzers.ruleset";
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
