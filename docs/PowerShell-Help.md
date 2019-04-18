# PowerShell Helpers
Here's some helpers for writing PowerShell scripts

## Getting Type of Variable

```powershell
[string[]] $list = git branch -a;
$list2 = git branch -a
Write-Prompt $list.GetType().FullName;
Write-Prompt $list2.GetType().FullName;

# > System.String[]
# > System.Object[]
```

## Adding to list returns index
Here's how to add to a list without returning the index.

See also:
[Best method for ignoring output](https://stackoverflow.com/questions/5260125/whats-the-better-cleaner-way-to-ignore-output-in-powershell)

```powershell
$list.Add("test") > $null;
[void]$list.Add("test");
$null = $list.Add("test")
$list.Add("test") | Out-Null;
```

## Metrics
To get metrics against a command

```powershell
Measure-Command {$(1..1000) > $null}
Measure-Command {$null = $(1..1000)}
```
