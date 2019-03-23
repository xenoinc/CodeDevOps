# Damian Suess
# Rev1: 2018-11-01
# Update dependencies locally when you need exec files from
# the HostProj but they're not ready on the build server yet.
# This copies them locally to the child project's "Lib\2nd_Party" folder
#
# Old method used BAT file ``xcopy``. This uses PowerShell
#

function Copy2($fileName)
{
  $src = "C:\projs\HostProj_NotOnBuildServer\output";
  $destLib = Join-Path -Path "$pwd" -ChildPath "lib\2nd_Party\HostProject";
  $destOut = Join-Path -Path "$pwd" -ChildPath "output";

  CopyIfFolderExists($fileName)($src)($destLib);
  CopyIfFolderExists($fileName)($src)($destOut);
  Write-Host "helo";
}

function CopyIfFolderExists($fileName, $srcDir, $destDir)
{
  if ([System.IO.Directory]::Exists("$destDir"))
  {
    $from = Join-Path -Path "$srcDir" -ChildPath "$fileName";
    $to = Join-Path -Path "$destDir" -ChildPath "$fileName";

    Copy-Item "$from" -Destination "$to";
    Write-Host "Copying '$fileName' from [$srcDir] to [$destDir]";
  }
}

Copy2("File1.exe");
Copy2("File2.dll");
Copy2("File3.dll");
Copy2("File4.dll");

# Write-Host "Does Temp folder exist:" . [System.IO.Directory]::Exists('C:\temp\');

<#
REM Old Method

SET source="C:\projs\HostProj_NotOnBuildServer\ouput"
SET dest="%cd%\lib\2nd_Party\HostProject\"

xcopy "%source%\File1.exe" %dest% /y
xcopy "%source%\File2.dll" %dest% /y
xcopy "%source%\File3.dll" %dest% /y
xcopy "%source%\File4.dll" %dest% /y
#>
