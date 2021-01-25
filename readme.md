# PowerShell DevOps
Development Operations for command line productivity using PowerShell.

This project started as an internal tool used by Xeno Innovations - hence the focus on git and the default ``develop`` branch. We'll do our best to keep things generic for the open source community.

## Installation
1. Download or clone the repo your local folder (_i.e. ``C:\BuildTools\``_)
2. Set your ``Path`` **Environment Variables** to your extracted folder.
3. Close and re-open any open command prompts
4. _Enjoy!_


## Road map
* Install / update Xeno-DevOps from CLI
* Update Visual Studio project rule sets
    * i.e. _EditorConfig, StyleCop, CodeMaid, Spelling_)
* Create new project folder template
    * Makes standard folder structure, readme, MSBuild, rules, etc.

```
                      `.---.`             ``.---.
                 `:ohmmNNNNNmho.     `-+osysoo+oyh:
               .ohyo/:---:+ymNNm+ `/shy+:.`     .dm`
             `+h+-`         .+dNNhhs:.          /Nm.
            `ys-             `sNNd.           `oNNo`
           `y+`             /hsdNh`         `+dNd+`
           os`            .hh:`yNo       `:ymNh+.
          .h-            /ms. `dd-  `./ohmdy+-`
          :y`        ```+Nh:-:oNhosyyys+/-`
         `+h/+oo-..    ydNmysosms:-..`
     `:osyhd+/::--...`.dNo` :d/`         .`
   `+hs:-`-h`         /NN+`oh:           s:
  `yd:`   `+`         sNNhhs-           `d-
  /Ns                 oNNm/`            oy`
  +Nm/`            `-ohmNNh.          `oh-
  -hNNdo:.`````.:+ydy/.:dNNNs-`     `/yo.
   .smNNNNNNNNNNmy+-`   .smNNNNdhyyhh+-
     `:+ossso+:-`         `:+syyyo/-`

  -- Xeno Innovations --
```

# Using DevOps Git Commands
The base library for all Git commands.

## [GitSync](https://github.com/xenoinc/XenoDevOps/wiki/GitSync)
Synchronizes (``merge``) your current branch with another branch; using ``develop`` by default.

### Usage:
Syncing your branch with the latest develop branch.

#### Xeno-DevOps Solution
```powershell
[feature/MyBranch]> GitSync
Sync complete!
```

#### Old Stinky Method
```powershell
[feature-MyBranch]> git checkout develop
[develop]> git pull
[develop]> git checkout feature-MyBranch
[feature-MyBranch]> git merge develop
```

## [GitCheckout](https://github.com/xenoinc/XenoDevOps/wiki/GitCheckout)
Checks out your branch in the following execution order
1. Attempt locally
2. Attempt on ``origin``
3. Fetch, then try ``origin`` again.

_In the future we will provide the option for a different remote_

### Usage
```powershell
GitCheckout MyBranch
GitCheckout feature/MyBranch
GitCheckout "feature/MyBranch"
```

## [GitCommit](https://github.com/xenoinc/XenoDevOps/wiki/GitCommit)
Commits changes with provided message. Optionally ``push``es up branch.

### Usage
```powershell
GitCommit "My message" -push
GitCommit "My message" -push
```

## [GitPrune](https://github.com/xenoinc/XenoDevOps/wiki/GitPrune)
Fetch and prune your repository.

#### Usage
```powershell
GitPrune          ; Fetch and prune
```

### [GitPush](https://github.com/xenoinc/XenoDevOps/wiki/GitPush)
Pushes your branch to ``origin`` without the annoying prompt when you're not tracking

#### Usage
* ``GitPush`` - Pushes your branch without tracking current branch
* ``GitPush -track`` Pushes up branch and sets to track your branch, giving accessibility to ``git push`` in the future.


### [GitStatus](https://github.com/xenoinc/XenoDevOps/wiki/GitStatus)
Report stats about your current branch

#### Usage
```powershell
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
