# Integration checks use disposable repositories; never the caller's branches.
$ErrorActionPreference = 'Stop'
$scriptPath = (Resolve-Path "$PSScriptRoot/../GitPrune.ps1").Path
$testRoot = Join-Path ([IO.Path]::GetTempPath()) ("GitPrune-tests-" + [guid]::NewGuid())
New-Item -ItemType Directory -Path $testRoot | Out-Null

function Invoke-TestGit {
  & git @args | Out-Null
  if ($LASTEXITCODE -ne 0) { throw "Test setup command failed: git $args" }
}

function Assert-Branch([string] $Name, [bool] $Exists) {
  $refs = @(git for-each-ref '--format=%(refname:strip=2)' refs/heads/)
  if ($LASTEXITCODE -ne 0) { throw 'Cannot inspect test branches.' }
  if (($refs -ccontains $Name) -ne $Exists) {
    throw "Branch '$Name': expected Exists=$Exists."
  }
}

function Assert-Fails([scriptblock] $Action) {
  $failed = $false
  try { & $Action } catch { $failed = $true }
  if (-not $failed) { throw 'Expected operation to fail.' }
}

Push-Location $testRoot
try {
  Invoke-TestGit init --bare remote.git
  Invoke-TestGit init --initial-branch=main local
  Set-Location local
  Invoke-TestGit config user.name 'GitPrune Test'
  Invoke-TestGit config user.email 'gitprune@example.invalid'
  Invoke-TestGit commit --allow-empty -m initial
  Invoke-TestGit remote add origin ../remote.git
  Invoke-TestGit push -u origin main
  Invoke-TestGit branch gone
  Invoke-TestGit push -u origin gone
  Invoke-TestGit branch renamed
  Invoke-TestGit branch --set-upstream-to=origin/main renamed
  Invoke-TestGit branch feature/present
  Invoke-TestGit push origin feature/present
  Invoke-TestGit branch local-only
  Invoke-TestGit branch held
  Invoke-TestGit worktree add ../held held
  Invoke-TestGit remote add upstream ../remote.git
  Invoke-TestGit fetch upstream
  Invoke-TestGit branch other-remote
  Invoke-TestGit branch --set-upstream-to=upstream/main other-remote
  Invoke-TestGit checkout -b unmerged
  Invoke-TestGit commit --allow-empty -m unmerged
  Invoke-TestGit checkout main
  Invoke-TestGit push origin --delete gone

  & $scriptPath
  Assert-Branch gone $true
  Assert-Branch local-only $true
  $goneRef = @(git for-each-ref '--format=%(refname)' refs/remotes/origin/gone)
  if ($goneRef.Count -ne 0) { throw 'Default mode did not prune stale remote ref.' }

  & $scriptPath -Sync -WhatIf
  Assert-Branch gone $true
  & $scriptPath -Sync
  Assert-Branch gone $false
  Assert-Branch renamed $true
  Assert-Branch local-only $true
  Assert-Branch other-remote $true

  & $scriptPath -All -Force -WhatIf
  Assert-Branch local-only $true
  Assert-Branch unmerged $true
  Assert-Fails { & $scriptPath -All }
  Assert-Branch local-only $false
  Assert-Branch renamed $false
  Assert-Branch unmerged $true
  Assert-Branch held $true
  Assert-Branch main $true
  Assert-Branch feature/present $true

  & $scriptPath -All -Force
  Assert-Branch unmerged $false
  Assert-Branch held $true
  Assert-Branch main $true

  # Selected remote, even when empty, and an absent current branch.
  Invoke-TestGit init --bare ../empty.git
  Invoke-TestGit remote add empty ../empty.git
  Invoke-TestGit branch empty-candidate
  & $scriptPath -All -Remote empty -Force
  Assert-Branch empty-candidate $false
  Assert-Branch main $true
  Assert-Branch held $true

  Invoke-TestGit branch fetch-failure-survivor
  Invoke-TestGit remote set-url origin ../does-not-exist.git
  Assert-Fails { & $scriptPath -All -Force }
  Assert-Branch fetch-failure-survivor $true
  Assert-Fails { & $scriptPath -All -Remote missing }
  Write-Host 'All GitPrune integration checks passed.' -ForegroundColor Green
} finally {
  Pop-Location
  Write-Host "Disposable test repositories: $testRoot"
}
