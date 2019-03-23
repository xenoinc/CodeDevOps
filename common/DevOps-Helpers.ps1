
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
