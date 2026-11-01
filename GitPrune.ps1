<#
  Git commandline helpers for PowerShell
  Author: Damian Suess
  Revision: 2 - 2026-11-01

  Usage:
    GitPrune                         ; Fetch and prune origin
    GitPrune -Sync                   ; Delete locals whose remote upstream is gone
    GitPrune -DeleteMissing          ; Delete local names missing from the remote
    GitPrune -DeleteMissing -WhatIf  ; Preview local branch deletion
    GitPrune -DeleteMissing -Force   ; Also delete unmerged local branches
    GitPrune -DeleteMissing -Remote upstream ; Compare against another remote

  Notes:
    - Remote defaults to origin. No branches are deleted on the server.
    - Sync checks configured upstreams; DeleteMissing compares branch names,
      including branches with no upstream. Names are case-sensitive.
    - Branches checked out in any worktree are skipped.
    - Deletion uses git branch -d; Force uses git branch -D.
    - WhatIf still fetches and prunes remote-tracking refs, but deletes no locals.
    - A failed fetch stops local branch cleanup.

  Change Log:
    2026-11-01 - 0.2 - Added DeleteMissing, Remote, Force, and WhatIf support
    2019-03-21 - 0.1 - Created
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
  [switch] $Sync,
  [switch] $DeleteMissing,
  [ValidateNotNullOrEmpty()]
  [string] $Remote = 'origin',
  [switch] $Force
)

$ErrorActionPreference = 'Stop'

$remotes = @(git remote)
if ($LASTEXITCODE -ne 0) { throw 'Cannot enumerate remotes. Run this script inside a Git repository.' }
if ($remotes -cnotcontains $Remote) { throw "Remote '$Remote' is not configured in this repository." }

# Fetch first; a failed fetch must never lead to local deletion.
git fetch --prune -- $Remote
if ($LASTEXITCODE -ne 0) { throw "Fetch/prune failed for '$Remote'; no local branches were deleted." }

if (-not ($Sync -or $DeleteMissing)) {
  Write-Host "Fetch and prune completed for '$Remote'." -ForegroundColor Green
  return
}

$remotePrefix = "refs/remotes/$Remote/"
$remoteRefs = @(git for-each-ref '--format=%(refname)' refs/remotes/)
if ($LASTEXITCODE -ne 0) { throw 'Cannot enumerate remote-tracking branches.' }
$remoteNames = New-Object 'System.Collections.Generic.HashSet[string]' ([StringComparer]::Ordinal)
$remoteRefSet = New-Object 'System.Collections.Generic.HashSet[string]' ([StringComparer]::Ordinal)
foreach ($ref in $remoteRefs) {
  if ($ref.StartsWith($remotePrefix, [StringComparison]::Ordinal)) {
    [void] $remoteRefSet.Add($ref)
    [void] $remoteNames.Add($ref.Substring($remotePrefix.Length))
  }
}

# Ref fields avoid parsing localized, decorated output from git branch -vv.
$localRefs = @(git for-each-ref '--format=%(refname:strip=2)%09%(upstream)%09%(worktreepath)' refs/heads/)
if ($LASTEXITCODE -ne 0) { throw 'Cannot enumerate local branches.' }

$deleted = 0
$failed = @()
foreach ($line in $localRefs) {
  $branch, $upstream, $worktreePath = $line -split "`t", 3
  if ($DeleteMissing) {
    $candidate = -not $remoteNames.Contains($branch)
  } else {
    $candidate = $upstream.StartsWith($remotePrefix, [StringComparison]::Ordinal) -and
      -not $remoteRefSet.Contains($upstream)
  }
  if (-not $candidate) { continue }

  if ($worktreePath) {
    Write-Warning "Skipping '$branch': checked out in '$worktreePath'."
    continue
  }

  $deleteOption = '-d'
  $action = 'Delete local branch (git branch -d)'
  if ($Force) {
    $deleteOption = '-D'
    $action = 'Force-delete local branch, including unmerged commits (git branch -D)'
  }
  if ($PSCmdlet.ShouldProcess($branch, $action)) {
    git branch $deleteOption -- $branch
    if ($LASTEXITCODE -ne 0) {
      $failed += $branch
    } else {
      $deleted++
    }
  }
}

if ($failed.Count -gt 0) {
  throw "Could not delete local branches: $($failed -join ', '). Git's diagnostics above explain why."
}
Write-Host "Git prune completed. Deleted $deleted local branch(es)." -ForegroundColor Green
