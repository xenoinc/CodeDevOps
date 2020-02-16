# DevOps Command Line Tools

## New Project
Creates a base project structure folder structure and supporting files

### Project Types
There are templates for both **test-bench** and **full** projects. The _test-bench_ projects only contain simple file and folder structures, whereas the _full_ projects house proper source code and documentation folders.

### Command Switches

``DevOps -new -test "Test.MaterialDesign"``

| Param           | Description |
|-----------------|-------------|
| -[n]ew (name)   | New project with name
| -[t]est         | Test Bench
| -[l]ang (name)  | Language (C# default)
| -[h]elp         | Help
| -[ns]ub         | Don't create subfolder

#### Suggested Language Types
* C# - Xamarin, .NET Core
* Arduino - C++ project
    * Based on [PlatformIO](https://platformio.org/) folder structure

### Folder Structures
