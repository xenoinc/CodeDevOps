# DevOps
Development Operations for command line productivity with PowerShell on Windows. This is an internal tool used by Xeno Innovations, if you find it useful, use it.

Well do our best to keep things generic for public use.

## Installation
We do plan on having an installer in the future. Since we're prototyping, use the following:

1. Download or clone the repo to a folder (_i.e. ``C:\BuildTools\`` _)
2. Set your ``Path`` **Environment Variables** to your extracted folder.
3. Close and re-open any open command prompts
4. _Enjoy!_


## Road map
Currently Xeno-DevOps only supports shortcuts to Git commands. In the future we will have the following:
* Install / update Xeno-DevOps from CLI
* Update Visual Studio project rule sets
    * i.e. _EditorConfig, StyleCop, CodeMaid, Spelling_)
* Create new project folder template
    * Makes standard folder structure, readme, MSBuild, rules, etc.

# Use It
## Git Commands
The base library for all Git commands.

### GitSync
Synchronizes your current branch with ``develop`` branch.

``Check-out develop >> Pull latest >> Check-out branch >> Merge with develop``
_NOTE: You must have a "develop" branch_

#### Usage:
```
GitSync
```

### GitCheckout
Checks out your branch in the following execution order
1. Attempt locally
2. Attempt on ``origin``
3. Fetch, then try ``origin`` again.

_In the future we will provide the option for a different remote_

#### Usage
```
GitCheckout MyBranch
GitCheckout feature/MyBranch
GitCheckout "feature/MyBranch"
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

## PowerShell
### Execution Policies

``get-executionpolicy``

``get-executionpolicy -list``

``get-executionpolicy -scope currentuser``

Sets a policy
``Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser``
