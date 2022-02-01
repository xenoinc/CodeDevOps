# DevOps - Git Commands

## Feature Requests
The following are feature requests, which necessarily won't always get in.

### Link branches
2019-04-01
Consider creating a shortcut command which links our current branch to one on the server with the same name. This comes handy when we forget to set upstream tracking on branches such as ``develop``

Example:
```
git branch --set-upstream-to=origin/develop
```

## Commands

### GitSync
Synchronizes your current branch with ``develop`` branch.

``Check-out develop >> Pull latest >> Check-out branch >> Merge with develop``
_NOTE: You must have a "develop" branch_

#### Usage:
```
GitSync
```

### GitCommit
Commits changes with provided message. Optionally ``push``es up branch.

#### Usage
```
GitCommit "My message" -push
```

#### Usage
* ``GitCheckIn "This is a commit message"`` - Commits and pushes
* ``GitCheckIn "This is a commit message" -a`` - Not working currently

### GitPrune
Fetch and prune your repository. Optionally ``sync`` with remote, removing local branches no longer on remote.

#### Usage
```
GitPrune          ; Fetch and prune
GitPrune -sync    ; Remove local branches already merged
```

### GitPush
Pushes your branch to ``origin`` without the annoying prompt when you're not tracking

#### Usage
* ``GitPush`` - Pushes your branch without tracking current branch
* ``GitPush -track`` Pushes up branch and sets to track your branch, giving accessibility to ``git push`` in the future.


### GitStatus
Report stats about your current branch

#### Usage
```
GitStatus

Results ===========================================
Name                           Value
----                           -----
Branch-Name:                   feature/VsTemplates
Ahead-Count:                   0
Ahead:                         False
Untracked:                     False
Added-Files:                   0
Modified-Files:                0
Deleted:                       1
GitStatus completed.
```
