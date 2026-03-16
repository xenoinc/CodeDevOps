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
  [parameter(Mandatory=$false)][string] $help ="",
  [parameter(Mandatory=$false)][string] $get = ""
#  , [parameter(Mandatory=$false)][bool] $GetFramework
#  # ,[parameter(Mandatory=$false)][switch] $track = $false
);

# Include Files --------
. "$PSScriptRoot/lib/DevOpsHelpers.ps1";

### Write-Output $("path " + GetSourceFolder);
##$srcFolder = GetSourceFolder;
##if ($srcFolder -eq [String]::Empty)
##{
##  Write-Output "Missing 'source' or 'src' folder. Make sure you're in project root.";
##  exit;
##}

function DisplayHelp()
{
  # Write-Output "Current Path:   '$pwd'";
  # Write-Output "Script Root:    '$PSScriptRoot'";
  Write-Output "";
  Write-Output "Usage:";
  Write-Output "  DevOps /help             - Help documentation";
  Write-Output "  DevOps -get <OPTION>     - Imports core project file(s) for option";
  Write-Output "";
  Write-Output "Sample:";
  Write-Output "  DevOps -get gitignore    - Imports .GitIgnore file to current directory";
  Write-Output "";
  Write-Output "Options:";
  Write-Output "  ALL           - Updates all files except GitIgnore";
  Write-Output "  ClangFormat   - .clang-format file";
  Write-Output "  CodeMaid      - C# 'CodeMaid.config' file";
  Write-Output "  EditorConfig  - Generic configuration for all languages";
  Write-Output "  GitIgnore     - Generic .gitignore for common projects";
  Write-Output "  LicenseHeader - Visual Studio License Header specifications (deprecated)";
  Write-Output "  MD            - Markdown Lint";
  Write-Output "  SpellChecker  - '.vsspell' (deprecated; use EditorConfig)";
  Write-Output "  StyleCop";
  Write-Output "  XamlStyler";
}

if ($PSBoundParameters.ContainsKey('help') -eq $true)
{
  DisplayHelp;
  exit;
}

# Parse commands
$get = $get.Trim();

switch -Exact ($get.ToLower())
{
  # "all" files switch
  "all".ToLower()
  {
    Write-Output "** Updating All **";
    CopyTemplate("Clang-Format/.clang-format")($pwd);
    CopyTemplate("CodeMaid/CodeMaid.config")($pwd);
    CopyTemplate("EditorConfig/.editorconfig")($pwd);
    CopyTemplate("LicenseHeader/.licenseheader")($pwd);
    CopyTemplate("Markdown/.markdownlint.json")($pwd);
    CopyTemplate("SpellChecker/SpellChecker.ruleset")($pwd);
    CopyTemplate("SpellChecker/.vsspell")($pwd);
    CopyTemplate("StyleCop/StyleCop.Analyzers.ruleset")($pwd);
    CopyTemplate("StyleCop/stylecop.json")($pwd);
    CopyTemplate("XamlStyler/Settings.XamlStyler")($pwd);
    break;
  }

  # Individual arguments
  "ClangFormat".ToLower()   { CopyTemplate("Clang-Format/.clang-format")($pwd); break; }
  "CodeMaid".ToLower()      { CopyTemplate("CodeMaid/CodeMaid.config")($pwd); break; }
  "EditorConfig".ToLower()  { CopyTemplate("EditorConfig/.editorconfig")($pwd); break; }
  "GitIgnore".ToLower()     { CopyTemplate("Git/.gitignore")($pwd); break; }
  "LicenseHeader".ToLower() { CopyTemplate("LicenseHeader/.licenseheader")($pwd); break; }
  "MD".ToLower()            { CopyTemplate("Markdown/.markdownlint.json")($pwd); break; }
  "SpellChecker".ToLower()
  {
    CopyTemplate("SpellChecker/SpellChecker.ruleset")($pwd);
    CopyTemplate("SpellChecker/.vsspell")($pwd);
    break;
  }
  "StyleCop".ToLower()
  {
    CopyTemplate("StyleCop/StyleCop.Analyzers.ruleset")($pwd);
    CopyTemplate("StyleCop/stylecop.json")($pwd);
    break;
  }
  "XamlStyler".ToLower() { CopyTemplate("XamlStyler/Settings.XamlStyler")($pwd); break; }
  default
  {
    Write-Output "Invalid DevOps -get command, '$get'";
    DisplayHelp;
  }
}
