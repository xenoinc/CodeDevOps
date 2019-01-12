# Git Commands

## GitTools
The base library for all Git commands.

## GitSync
Syncronizes your current branch with ``develop`` branch.

Warning: You must have a "develop" branch

### Functionality
1. Checks out ``develop`` branch
2. Pulls latest from ``develop`` branch
3. Switches back to your current working branch
4. Merges with latest ``develop`` branch

## GitCheckIn
Checks-in changes with provided message then ``push``es up branch.

### Parameters
* $msg - Your check-in message (required)
* -a - Adds all files to check-in automatically (default false)

### Usage
* ``GitCheckIn "This is a commit message"`` - Commits and pushes
* ``GitCheckIn "This is a commit message" -a`` - Not working currently


## GitPush
Pushes your branch to ``origin``



### Usage
* ``GitPush`` - Pushes your branch without tracking current branch
* ``GitPush -track`` Pushes up branch and sets to track your branch, giving accessability to ``git push`` in the future.


# PowerShell
## Execution Policies

``get-executionpolicy``

``get-executionpolicy -list``

``get-executionpolicy -scope currentuser``

Sets a policy
``Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser``
