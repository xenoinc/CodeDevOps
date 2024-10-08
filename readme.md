# PowerShell DevOps

Xeno Innovations' DevOps (Development Operations) command line tool provides users a quick-set of **Git command helpers** and **project configs** to increase your productivity via PowerShell.

The **Git helpers** provide shortcuts for popular commands such as, `gitpull`, `gitpush`, `gitcommit`, so you don't have to remember switches. Also provides, `gitsync`, which synchronizes your current branch with `develop` (by default) or a branch of our choosing.

The `devops` command provides project configurations to ensure all projects stay aligned with the same ruleset.

Since our primary focus is on projects made with Visual Studio and VS Code, the rule sets cover a wide range of C# for Xamarin/MAUI, desktop and ASP.NET Core, as well as C/C++ (including Arduino).

This project started as an internal tool used by Xeno Innovations and Suess Labs - _hence the focus on git and the default ``develop`` branch_. We'll do our best to keep things generic for the open source community.

## Installation

1. Download or clone the repo your local folder (_i.e. ``C:\BuildTools\``_)
2. Set your ``Path`` **Environment Variables** to your extracted folder.
3. Close and re-open any open command prompts
4. _Enjoy!_

## Road map

* Install / update Xeno-DevOps from CLI
* Create new project folder template
  * Makes standard folder structure, readme, MSBuild, rules, etc.

```text
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

## [GitSync](https://github.com/xenoinc/XenoDevOps/wiki/GitSync)

Synchronizes (`merge`) your current branch with another branch; using `develop` by default.

### Usage

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

Note: _In the future we will provide the option for a different remote_

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

## References

Sponsored by, Suess Labs
