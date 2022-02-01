# Introduction
This space maintains the standards for coding, development, operations, and scripts for Xeno Innovations' projects.

## Folder Structure

## Style A - Base Folder
This style can be used for smaller projects which don't take as many custom editor files.

An example would be, Visual Studio using a single project
```
.gitignore
readme.md
*.sln
.editorconfig
\SOLUTION_NAME\
\docs\
```

## Style B - Sub Folder (larger)
Used for larger projects and places your solution and sub-projects into the subfolder "source".

```
.gitignore
readme.md
build.proj
BuildProperties.resx
\docs\
\source\*.sln
\source\.editorconfig
\source\codemaid.config
\source\SOLUTION_NAME.sln.licenseheader
\source\stylecop.json
\source\StyleCop.Analyzers.ruleset
```

## StyleCop
Files required for StyleCop.Analyzers. To include with your .NET Standard for Xamarin.Forms projects, refer to this [StackOverflow response](https://stackoverflow.com/questions/52742473/how-to-get-a-stylecop-ruleset-trough-nuget-in-a-net-standard-project/54063152#54063152).

## EditorConfig
Code spacing specifications are maintained in the ``.EditorConfig`` file. We have traditionally and currently stick to a 2-spaces rule.

## CodeMaid
``Rules coming soon``
See also, [CodeMaid docs](http://www.codemaid.net/)

## SpellChecker
``Rules coming soon``
See also, [VSSpellChecker docs](https://github.com/EWSoftware/VSSpellChecker/wiki)
