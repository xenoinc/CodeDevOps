# Damian Suess
# Rev1: 2018-11-01
# Update Dependencies Locally

function Copy2($fileName)
{
  $src = "C:\dev\RBT-RedRock.Control\Project\Renaissance\Debug";
  $destLib = Join-Path -Path "$pwd" -ChildPath "lib\2nd_Party\Renaissance";
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

Copy2("HWCApplication.exe");
Copy2("RobotShell.exe");
Copy2("SCCApplication.exe");
Copy2("TestBenchApplication.exe");
Copy2("AstVisionLib.dll");
Copy2("CompatibilityTester.dll");
Copy2("CompatibilityTester.Tests.dll");
Copy2("CustomControls.dll");
Copy2("Local System Library.Native.Tests.dll");
Copy2("Local System Library.Tests.dll");
Copy2("RobotApplicationLauncher.dll");
Copy2("RobotControls.dll");
Copy2("RobotHardwareLauncher.dll");
Copy2("sd2.dll");
Copy2("System.Windows.Forms.dll");
Copy2("TypeLibs.dll");


#Write-Host "Does it: :" . [System.IO.Directory]::Exists('C:\temp\');

<#

SET source="C:\dev\RBT-RedRock.Control\Project\Renaissance\Debug"
SET dest="%cd%\lib\2nd_Party\Renaissance\"

xcopy "%source%\HWCApplication.exe" %dest% /y
xcopy "%source%\RobotShell.exe" %dest% /y
xcopy "%source%\SCCApplication.exe" %dest% /y
xcopy "%source%\TestBenchApplication.exe" %dest% /y
xcopy "%source%\AstVisionLib.dll" %dest% /y
xcopy "%source%\CompatibilityTester.dll" %dest% /y
xcopy "%source%\CompatibilityTester.Tests.dll" %dest% /y
xcopy "%source%\CustomControls.dll" %dest% /y
xcopy "%source%\Local System Library.Native.Tests.dll" %dest% /y
xcopy "%source%\Local System Library.Tests.dll" %dest% /y
xcopy "%source%\RobotApplicationLauncher.dll" %dest% /y
xcopy "%source%\RobotControls.dll" %dest% /y
xcopy "%source%\RobotHardwareLauncher.dll" %dest% /y
xcopy "%source%\sd2.dll" %dest% /y
xcopy "%source%\System.Windows.Forms.dll" %dest% /y
xcopy "%source%\TypeLibs.dll" %dest% /y

#>