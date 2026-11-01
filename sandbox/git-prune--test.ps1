$ErrorActionPreference = 'Stop'
$remoteBranches = @(git for-each-ref --format='%(refname:strip=3)' refs/remotes/origin)

if ($LASTEXITCODE -ne 0) { throw 'Cannot enumerate remote branches.' }

$currentBranch = git branch --show-current
$localBranches = @(git for-each-ref --format='%(refname:short)' refs/heads)

if ($LASTEXITCODE -ne 0) { throw 'Cannot enumerate local branches.' }

$candidates = @($localBranches | Where-Object { $_ -ne $currentBranch -and $_ -notin $remoteBranches })

foreach ($branch in $candidates) {
  git merge-base --is-ancestor $branch origin/develop
  if ($LASTEXITCODE -ne 0) { throw "Branch is not merged into origin/develop: $branch" }
}

foreach ($branch in $candidates) {
  git branch -d -- $branch
  if ($LASTEXITCODE -ne 0) { throw "Could not safely delete branch: $branch" }
}

"Deleted $($candidates.Count) local branches."
git branch -vv
git status --short
